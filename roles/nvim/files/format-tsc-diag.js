const {
  formatDiagnosticMessage,
  // this is the path to the pretty-ts-errors repo.
  // you have to build the formatter and util packages.
} = require("../../../../code/pretty-ts-errors/packages/formatter/dist/index.js");

const args = process.argv.slice(2); // Get only the custom arguments

let message = args[0];
if (!message) process.exit(1);
console.log(
  formatDiagnosticMessage(message, (code, language, multiline) => {
    // TODO: Figure out how to make these look better.
    if (language && multiline) {
      return `\`\`\`${language}
${code}
\`\`\``;
    }
    if (multiline) {
      return `\`\`\`
${code}
\`\`\``;

    }
    return `\`${code}\``;
  })
);
