const { formatDiagnosticMessage } = require("@pretty-ts-errors/formatter");
// Helper functions (codeblock, fixLists) remain the same...

module.exports = (plugin) => {
  plugin.setOptions({ dev: true });

  // Register a synchronous function callable from Lua/Vimscript
  plugin.registerFunction(
    "PrettyTsFormat",
    async ([message]) => {
      let result = formatDiagnosticMessage(message, codeblock);
      result = fixLists(result);
      return result
    },
    { sync: false }
  ); // 'sync: true' allows Lua to get the return value immediately

  // Register a command named "HelloNode"
  plugin.registerCommand(
    "HelloNode",
    async () => {
      await plugin.nvim.outWrite("Hello from Node.js!\n");
    },
    { sync: false }
  );

  // Register a function that can be called from VimScript/Lua
  plugin.registerFunction(
    "AddNumbers",
    async (args) => {
      const [a, b] = args;
      return a + b;
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
