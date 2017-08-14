"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const which = require("which");
const fs = require("fs");
const path = require("path");
const _ = require("lodash");
const child_process_1 = require("child_process");
const substituteVariables = require('var-expansion').substituteVariables; // no types available
const slash = require('slash'); // no types available
exports.headerExts = ['.h', '.H', '.hh', '.hpp', '.h++', '.hxx'];
class Linter {
    constructor(name, settings, workspaceRoot, requireConfig) {
        this.name = name;
        this.settings = settings;
        this.workspaceRoot = workspaceRoot;
        this.requireConfig = requireConfig;
        this.enabled = true;
        this.active = true;
        this.language = settings['c-cpp-flylint'].language;
        this.standard = settings['c-cpp-flylint'].standard;
        this.defines = settings['c-cpp-flylint'].defines;
        this.undefines = settings['c-cpp-flylint'].undefines;
        this.includePaths = settings['c-cpp-flylint'].includePaths;
    }
    cascadeCommonSettings(key) {
        let checkKey = (item) => {
            return this.settings['c-cpp-flylint'][key].hasOwnProperty(item) &&
                this.settings['c-cpp-flylint'][key].hasOwnProperty(item) !== null &&
                this.settings['c-cpp-flylint'][key][item] !== null;
        };
        let maybe = (orig, maybeKey) => {
            if (checkKey(maybeKey)) {
                if (_.isArray(orig)) {
                    return this.settings['c-cpp-flylint'][key][maybeKey];
                }
                else if (typeof orig === "string" || orig instanceof String) {
                    return this.settings['c-cpp-flylint'][key][maybeKey];
                }
            }
            return orig;
        };
        this.language = maybe(this.language, 'language');
        this.standard = maybe(this.standard, 'standard');
        this.defines = maybe(this.defines, 'defines');
        this.undefines = maybe(this.undefines, 'undefines');
        this.includePaths = maybe(this.includePaths, 'includePaths');
    }
    setExecutable(fileName) {
        this.executable = fileName;
    }
    setConfigFile(fileName) {
        this.configFile = fileName;
    }
    Name() {
        return this.name;
    }
    isEnabled() {
        return this.enabled === true;
    }
    isActive() {
        return this.active === true;
    }
    enable() {
        this.enabled = true;
    }
    disable() {
        this.enabled = false;
    }
    initialize() {
        return this.maybeEnable()
            .then(() => {
            return this;
        })
            .catch(() => {
            return this;
        });
    }
    maybeEnable() {
        if (!this.isEnabled()) {
            return Promise.resolve("");
        }
        return this.maybeExecutablePresent()
            .then((val) => {
            this.executable = val;
            return this.maybeConfigFilePresent();
        });
    }
    maybeExecutablePresent() {
        return new Promise((resolve, reject) => {
            let whichConfig = {};
            if (process.env.TRAVIS && process.env.TRAVIS === 'true') {
                whichConfig['path'] = process.cwd();
            }
            which(this.executable, whichConfig, (err, result) => {
                if (err) {
                    this.disable();
                    if (this.settings['c-cpp-flylint'].debug) {
                        console.log(`The executable was not found for ${this.name}; looked for ${this.executable}`);
                    }
                    reject(Error(`The executable was not found for ${this.name}, disabling linter`));
                }
                else
                    resolve(result);
            });
        });
    }
    maybeConfigFilePresent() {
        if (!this.requireConfig) {
            return Promise.resolve("");
        }
        return this.locateFile(this.workspaceRoot, this.configFile)
            .then((val) => {
            this.configFile = val;
            this.enable();
            return val;
        })
            .catch(() => {
            this.disable();
            throw Error(`could not locate configuration file for ${this.name}, disabling linter`);
        });
    }
    locateFile(directory, fileName) {
        return new Promise((resolve, reject) => {
            let parent = directory;
            do {
                directory = parent;
                const location = path.join(directory, fileName);
                try {
                    fs.accessSync(location, fs.constants.R_OK);
                    resolve(location);
                }
                catch (e) {
                    // do nothing
                }
                parent = path.dirname(directory);
            } while (parent !== directory);
            reject('could not locate file within project workspace');
        });
    }
    locateFiles(directory, fileName) {
        var locates;
        locates = [];
        fileName.forEach(element => {
            locates.push(this.locateFile(directory, element));
        });
        return Promise.all(locates);
    }
    expandVariables(str) {
        process.env.workspaceRoot = this.workspaceRoot;
        let { value, error } = substituteVariables(str, { env: process.env });
        if (error) {
            return { error: error };
        }
        else if (value === '') {
            return { error: `Expanding '${str}' resulted in an empty string.` };
        }
        else {
            return { result: slash(value) };
        }
    }
    buildCommandLine(fileName) {
        return [this.executable, fileName];
    }
    runLinter(params, workspaceDir) {
        let cmd = params.shift() || this.executable;
        if (this.settings['c-cpp-flylint'].debug) {
            console.log('executing: ', cmd, params);
        }
        return child_process_1.spawnSync(cmd, params, { 'cwd': workspaceDir });
    }
    lint(fileName, directory) {
        if (!this.enabled) {
            return [];
        }
        try {
            let result = this.runLinter(this.buildCommandLine(fileName), directory || this.workspaceRoot);
            let stdout = result.stdout !== null ? result.stdout.toString('utf-8').replace(/\r/g, "").split("\n") : [];
            let stderr = result.stderr !== null ? result.stderr.toString('utf-8').replace(/\r/g, "").split("\n") : [];
            if (this.settings['c-cpp-flylint'].debug) {
                console.log(stdout);
                console.log(stderr);
            }
            if (result.status != 0) {
                console.log(`${this.name} exited with status code ${result.status}`);
            }
            return this.parseLines(stdout.concat(stderr));
        }
        catch (e) {
            console.log(`An exception occurred in ${this.name} while parsing output for file ${fileName} stacktrace: ${e.stack}`);
            return [];
        }
    }
    parseLines(lines) {
        var results;
        var currentParsed;
        results = [];
        currentParsed = {};
        lines.forEach(line => {
            let parsed = this.parseLine(line);
            if (parsed !== {}) {
                ({ currentParsed, parsed } = this.transformParse(currentParsed, parsed));
                if (currentParsed !== undefined && currentParsed.hasOwnProperty('fileName')) {
                    // output an entry
                    results.push(currentParsed);
                }
                currentParsed = parsed;
            }
        });
        if (currentParsed !== undefined && currentParsed.hasOwnProperty('fileName')) {
            // output an entry
            results.push(currentParsed);
        }
        return results;
    }
    transformParse(currentParsed, parsed) {
        return { currentParsed: currentParsed, parsed: parsed };
    }
    parseLine(line) {
        line;
        return {};
    }
    isValidLanguage(language) {
        const allowLanguages = ['c', 'c++'];
        return _.includes(allowLanguages, language);
    }
    getIncludePathParams() {
        let paths = this.includePaths;
        let params = [];
        if (paths) {
            _.each(paths, (element) => {
                let value = this.expandVariables(element);
                if (value.error) {
                    console.log(`Error expanding include path '${element}': ${value.error.message}`);
                }
                else {
                    params.push(`-I`);
                    params.push(`${value.result}`);
                }
            });
        }
        return params;
    }
    expandedArgsFor(key, joined, values, defaults) {
        let params = [];
        if (values) {
            _.each(values, (element) => {
                let value = this.expandVariables(element);
                if (value.error) {
                    console.log(`Error expanding '${element}': ${value.error.message}`);
                }
                else {
                    if (joined) {
                        params.push(`${key}${value.result}`);
                    }
                    else {
                        params.push(key);
                        params.push(`${value.result}`);
                    }
                }
            });
        }
        else if (defaults) {
            _.each(defaults, (element) => {
                let value = this.expandVariables(element);
                if (value.error) {
                    console.log(`Error expanding '${element}': ${value.error.message}`);
                }
                else {
                    if (joined) {
                        params.push(`${key}${value.result}`);
                    }
                    else {
                        params.push(key);
                        params.push(`${value.result}`);
                    }
                }
            });
        }
        return params;
    }
}
exports.Linter = Linter;
//# sourceMappingURL=linter.js.map