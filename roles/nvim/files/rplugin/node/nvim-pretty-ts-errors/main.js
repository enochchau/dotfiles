const { formatDiagnosticMessage } = require("@pretty-ts-errors/formatter");
const readline = require("readline");

const args = process.argv.slice(2); // Get only the custom arguments

if (args.includes("--daemon")) {
  const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
    terminal: false,
  });

  rl.on("line", (line) => {
    try {
      if (!line.trim()) return;
      const { id, message } = JSON.parse(line);
      let result = formatDiagnosticMessage(message, codeblock);
      result = fixLists(result);
      console.log(JSON.stringify({ id, result }));
    } catch (e) {
      // Ignore errors to keep the daemon alive
    }
  });
} else {
  let message = args[0];
  if (!message) process.exit(1);
  let result = formatDiagnosticMessage(message, codeblock);
  result = fixLists(result);
  console.log(result);
}

function codeblock(code, language, multiline) {
  // TODO: Figure out how to make these look better.
  if (language && multiline) {
    if (language === "type") language = "typescript";
    return `
\`\`\`${language}
${code}
\`\`\`
`;
  }
  if (multiline) {
    return `
\`\`\`
${code}
\`\`\`
`;
  }
  return `\`${code}\``;
}

function fixLists(message) {
  return message.replace(/<ul>([\s\S]*?)<\/ul>/g, (match, listContent) => {
    return listContent
      .split(/<\/?li>/)
      .filter((item) => item.trim())
      .map((item, idx) => {
        let s = `* ${item.trim()}`;
        return idx === 0 ? "\n" + s : s;
      })
      .join("\n");
  });
}
