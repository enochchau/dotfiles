const { formatDiagnosticMessage } = require("@pretty-ts-errors/formatter");

module.exports = (plugin) => {
  plugin.setOptions({ dev: false });

  plugin.registerFunction(
    "PrettyTsFormat",
    async ([message]) => {
      let result = formatDiagnosticMessage(message, codeblock);
      result = fixLists(result);
      return result;
    },
    { sync: false }
  );
};

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
