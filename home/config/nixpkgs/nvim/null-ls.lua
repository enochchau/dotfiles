local null_ls = require("null-ls")

-- register any number of sources simultaneously
local sources = {
  null_ls.builtins.code_actions.gitsigns,
  null_ls.builtins.formatting.prettierd.with({
    env = {
      PRETTIERD_DEFAULT_CONFIG = vim.fn.expand("~/.config/nixpkgs/.prettierrc"),
    },
  }),
  null_ls.builtins.formatting.stylua,
  null_ls.builtins.diagnostics.vale,
}

null_ls.setup({ sources = sources })
