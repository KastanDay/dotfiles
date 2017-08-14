"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const path = require("path");
const util_1 = require("util");
const linter_1 = require("./linter");
class Flexelint extends linter_1.Linter {
    constructor(settings, workspaceRoot) {
        super('Flexelint', settings, workspaceRoot, true);
        this.cascadeCommonSettings('flexelint');
        this.executable = settings['c-cpp-flylint'].flexelint.executable;
        this.configFile = settings['c-cpp-flylint'].flexelint.configFile;
        this.active = this.enabled = settings['c-cpp-flylint'].flexelint.enable;
    }
    buildCommandLine(fileName) {
        var args = [
            this.executable,
            "-v",
            "-b",
            "-format=%f  %l %c  %t %n: %m",
            this.configFile,
            "-hsFr_1",
            "-width(4096,0)",
            "-zero(400)",
        ];
        if (linter_1.headerExts.indexOf(path.extname(fileName)) != -1) {
            var hArgs = this.settings['c-cpp-flylint'].flexelint.headerArgs;
            if (util_1.isString(hArgs)) {
                args.push(hArgs);
            }
            else {
                hArgs.forEach(element => {
                    args.push(element);
                });
            }
        }
        args.push(fileName);
        return args;
    }
    transformParse(currentParsed, parsed) {
        if ((parsed['code'] === "830" && parsed['message'] !== 'Location cited in prior message') || (parsed['code'] === "831" && parsed['message'] !== 'Reference cited in prior message')) {
            currentParsed['line'] = parsed['line'];
            currentParsed['column'] = parsed['column'];
            parsed = {};
        }
        else if (parsed['code'] === "830" || parsed['code'] === "831") {
            parsed = {};
        }
        return { currentParsed: currentParsed, parsed: parsed };
    }
    parseLine(line) {
        let regex = /^(.+?)\s\s([0-9]+)\s([0-9]+\s)?\s(Info|Warning|Error|Note)\s([0-9]+):\s(.*)$/;
        let regexArray;
        let excludeRegex = /^((During Specific Walk:|\s\sFile\s).*|)$/;
        if (excludeRegex.exec(line) != null) {
            // skip this line, so return that fact....
            return {};
        }
        if ((regexArray = regex.exec(line)) != null) {
            return {
                fileName: regexArray[1],
                line: parseInt(regexArray[2]) - 1,
                column: parseInt(regexArray[3]) || 0,
                severity: this.getSeverityCode(regexArray[4]),
                code: regexArray[5],
                message: regexArray[6],
                source: 'Flexelint',
            };
        }
        else {
            throw Error('Line could not be parsed: ' + line);
        }
    }
    getSeverityCode(severity) {
        return this.settings['c-cpp-flylint'].flexelint.severityLevels[severity];
    }
}
exports.Flexelint = Flexelint;
//# sourceMappingURL=flexelint.js.map