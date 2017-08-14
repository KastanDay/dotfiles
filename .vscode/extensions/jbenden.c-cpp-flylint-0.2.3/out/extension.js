"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const vscode_1 = require("vscode");
const vscode_languageclient_1 = require("vscode-languageclient");
const path = require("path");
function activate(context) {
    // The server is implemented in Node.
    const serverModule = context.asAbsolutePath(path.join("server", "server.js"));
    // The debug options for the server.
    const debugOptions = {
        execArgv: ["--nolazy", "--debug=6004"]
    };
    // If the extension is launched in debug mode the debug server options are used, otherwise the run options are used.
    const serverOptions = {
        run: {
            module: serverModule,
            transport: vscode_languageclient_1.TransportKind.ipc
        },
        debug: {
            module: serverModule,
            transport: vscode_languageclient_1.TransportKind.ipc,
            options: debugOptions
        }
    };
    // Options to control the language client.
    const clientOptions = {
        // Register the server for C/C++ documents.
        documentSelector: ["c", "cpp"],
        synchronize: {
            // Synchronize the setting section "c-cpp-flylint" to the server.
            configurationSection: "c-cpp-flylint",
            fileEvents: vscode_1.workspace.createFileSystemWatcher("**/.{clang_complete,flexelint.lnt}")
        }
    };
    // Create the language client and start it.
    const client = new vscode_languageclient_1.LanguageClient("C/C++ Flylint", serverOptions, clientOptions);
    client.onReady()
        .then(() => {
        client.onRequest('activeTextDocument', () => {
            return vscode_1.window.activeTextEditor.document;
        });
    });
    context.subscriptions.push(new vscode_languageclient_1.SettingMonitor(client, "c-cpp-flylint.enable").start());
}
exports.activate = activate;
//# sourceMappingURL=extension.js.map