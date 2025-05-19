const {
  formatDiagnosticMessage,
} = require("../../../../code/pretty-ts-errors/dist/format/formatDiagnosticMessage.js");

const args = process.argv.slice(2); // Get only the custom arguments

let message = args[0];
if (!message) process.exit(1);
console.log(formatDiagnosticMessage(message));
