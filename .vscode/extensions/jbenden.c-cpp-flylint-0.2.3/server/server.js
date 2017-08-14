"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : new P(function (resolve) { resolve(result.value); }).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
Object.defineProperty(exports, "__esModule", { value: true });
const vscode_languageserver_1 = require("vscode-languageserver");
const vscode_uri_1 = require("vscode-uri");
const path = require("path");
const _ = require("lodash");
const flexelint_1 = require("./linters/flexelint");
const cppcheck_1 = require("./linters/cppcheck");
const clang_1 = require("./linters/clang");
// Create a connection for the server. The connection uses Node's IPC as a transport.
const connection = vscode_languageserver_1.createConnection(new vscode_languageserver_1.IPCMessageReader(process), new vscode_languageserver_1.IPCMessageWriter(process));
// Create a simple text document manager. The text document manager supports full document sync only.
const documents = new vscode_languageserver_1.TextDocuments();
// Make the text document manager listen on the connection for open, change, and close text document events.
documents.listen(connection);
let settings;
let linters = [];
// After the server has started the client sends an initialize request.
// The server receives in the passed params the rootPath of the workspace plus the client capabilities.
let workspaceRoot;
connection.onInitialize((params) => {
    let workspaceUri = vscode_uri_1.default.parse(params.rootUri);
    if (workspaceUri.scheme !== 'file') {
        console.log('Workspace root URI is not of the file scheme.');
    }
    else {
        workspaceRoot = workspaceUri.fsPath;
    }
    let result = {
        capabilities: {
            textDocumentSync: documents.syncKind,
            executeCommandProvider: {
                commands: [
                    "c-cpp-flylint.analyzeActiveDocument",
                    "c-cpp-flylint.analyzeWorkspace"
                ]
            }
        }
    };
    return result;
});
// The content of a text document has changed.
// This event is emitted when the text document is first opened or when its content has changed.
documents.onDidChangeContent((event) => {
    if (settings['c-cpp-flylint'].run === "onType") {
        validateTextDocument(event.document);
    }
});
documents.onDidSave((event) => {
    if (settings['c-cpp-flylint'].run === "onSave" || settings['c-cpp-flylint'].run === "onType") {
        validateTextDocument(event.document);
    }
});
documents.onDidOpen((event) => {
    validateTextDocument(event.document);
});
// A text document was closed. Clear the diagnostics.
documents.onDidClose((event) => {
    connection.sendDiagnostics({ uri: event.document.uri, diagnostics: [] });
});
function validateTextDocument(textDocument) {
    const tracker = new vscode_languageserver_1.ErrorMessageTracker();
    const fileUri = vscode_uri_1.default.parse(textDocument.uri);
    const filePath = fileUri.fsPath;
    if (workspaceRoot === undefined ||
        workspaceRoot === null ||
        filePath === undefined ||
        filePath === null) {
        // lint can only successfully happen in a workspace, not per-file basis
        console.log("Will not analyze a lone file; must open a folder workspace.");
        return;
    }
    if (fileUri.scheme !== 'file') {
        // lint can only lint files on disk.
        tracker.add(`c-cpp-flylint: A problem was encountered; the document is not locally present on disk.`);
        // Send any exceptions encountered during processing to VSCode.
        tracker.sendErrors(connection);
        return;
    }
    if (linters === undefined || linters === null) {
        // cannot perform lint without active configuration!
        tracker.add(`c-cpp-flylint: A problem was encountered; the global list of analyzers is null or undefined.`);
        // Send any exceptions encountered during processing to VSCode.
        tracker.sendErrors(connection);
        return;
    }
    const documentLines = textDocument.getText().replace(/\r/g, '').split('\n');
    const diagnostics = [];
    const relativePath = path.relative(workspaceRoot, filePath);
    // deep-copy current items, so mid-stream configuration change doesn't spoil the party
    const lintersCopy = _.cloneDeep(linters);
    console.log('Performing lint scans...');
    lintersCopy.forEach(linter => {
        try {
            const result = linter.lint(filePath, workspaceRoot);
            for (const msg of result) {
                if (relativePath === msg['fileName'] || (path.isAbsolute(msg['fileName']) && filePath === msg['fileName'])) {
                    diagnostics.push(makeDiagnostic(documentLines, msg));
                }
            }
        }
        catch (e) {
            tracker.add(getErrorMessage(e, textDocument));
        }
    });
    console.log('Completed lint scans...');
    // Send the computed diagnostics to VSCode.
    connection.sendDiagnostics({ uri: textDocument.uri, diagnostics });
    // Send any exceptions encountered during processing to VSCode.
    tracker.sendErrors(connection);
}
function validateAllTextDocuments(textDocuments) {
    const tracker = new vscode_languageserver_1.ErrorMessageTracker();
    for (const document of textDocuments) {
        try {
            validateTextDocument(document);
        }
        catch (err) {
            tracker.add(getErrorMessage(err, document));
        }
    }
    tracker.sendErrors(connection);
}
function makeDiagnostic(documentLines, msg) {
    let severity = vscode_languageserver_1.DiagnosticSeverity[msg.severity];
    // 0 <= n
    let line;
    if (msg.line) {
        line = msg.line;
    }
    else {
        line = 0;
    }
    // 0 <= n
    let column;
    if (msg.column) {
        column = msg.column;
    }
    else {
        column = 0;
    }
    let message;
    if (msg.message) {
        message = msg.message;
    }
    else {
        message = "Unknown error";
    }
    let code;
    if (msg.code) {
        code = msg.code;
    }
    else {
        code = undefined;
    }
    let source;
    if (msg.source) {
        source = msg.source;
    }
    else {
        source = 'c-cpp-flylint';
    }
    let l = documentLines[line];
    let startColumn = column;
    let endColumn = column == 0 ? l.length : column + 1;
    if (column === 0) {
        let lineMatches = l.match(/\S/);
        if (lineMatches !== null) {
            startColumn = lineMatches.index;
        }
    }
    return {
        severity: severity,
        range: {
            start: { line: line, character: startColumn },
            end: { line: line, character: endColumn }
        },
        message: message,
        code: code,
        source: source,
    };
}
function getErrorMessage(err, document) {
    let errorMessage = "unknown error";
    if (typeof err.message === "string" || err.message instanceof String) {
        errorMessage = err.message;
    }
    const fsPathUri = vscode_uri_1.default.parse(document.uri);
    const message = `vscode-c-cpp-flylint: '${errorMessage}' while validating: ${fsPathUri.fsPath}. Please analyze the 'C/C++ FlyLint' Output console. Stacktrace: ${err.stack}`;
    return message;
}
// The settings have changed. Sent on server activation as well.
connection.onDidChangeConfiguration((params) => __awaiter(this, void 0, void 0, function* () {
    settings = params.settings;
    console.log('Configuration changed. Re-configuring extension.');
    linters = []; // clear array
    linters.push(yield (new clang_1.Clang(settings, workspaceRoot).initialize()));
    linters.push(yield (new cppcheck_1.CppCheck(settings, workspaceRoot).initialize()));
    linters.push(yield (new flexelint_1.Flexelint(settings, workspaceRoot).initialize()));
    _.forEach(linters, (linter) => {
        if (linter.isActive() && !linter.isEnabled()) {
            connection.window.showWarningMessage(`Unable to activate ${linter.Name()} analyzer.`);
        }
    });
    // Revalidate any open text documents.
    validateAllTextDocuments(documents.all());
}));
connection.onDidChangeWatchedFiles(() => {
    console.log('FS change notification occurred; re-linting all opened documents.');
    validateAllTextDocuments(documents.all());
});
connection.onExecuteCommand((params) => {
    const tracker = new vscode_languageserver_1.ErrorMessageTracker();
    if (params.command === 'c-cpp-flylint.analyzeActiveDocument') {
        connection.sendRequest('activeTextDocument')
            .then((activeDocument) => {
            if (activeDocument !== undefined && activeDocument !== null) {
                let fileUri = activeDocument.uri;
                for (const document of documents.all()) {
                    try {
                        const documentUri = vscode_uri_1.default.parse(document.uri);
                        if (fileUri.fsPath === documentUri.fsPath) {
                            validateTextDocument(document);
                        }
                    }
                    catch (err) {
                        tracker.add(getErrorMessage(err, document));
                    }
                }
            }
        });
    }
    else if (params.command === 'c-cpp-flylint.analyzeWorkspace') {
        validateAllTextDocuments(documents.all());
    }
    tracker.sendErrors(connection);
});
// Listen on the connection.
connection.listen();
//# sourceMappingURL=server.js.map