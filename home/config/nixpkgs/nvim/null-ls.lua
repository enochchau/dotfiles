local null_ls = require("null-ls")

-- register any number of sources simultaneously
local sources = {
  null_ls.builtins.code_actions.gitsigns,
  -- null_ls.builtins.formatting.eslint_d,
  -- null_ls.builtins.diagnostics.eslint_d,
  null_ls.builtins.formatting.prettierd.with({
    env = {
      PRETTIERD_DEFAULT_CONFIG = vim.fn.expand(
        "$XDG_CONFIG_HOME/nixpkgs/.prettierrc"
      ),
    },
  }),
  -- null_ls.builtins.code_actions.eslint_d,
  null_ls.builtins.formatting.stylua,
}

null_ls.setup({ sources = sources })
