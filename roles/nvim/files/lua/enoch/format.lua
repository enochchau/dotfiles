local fmt_select = require("nvim-format-select")

local fmt_on_save = vim.api.nvim_create_augroup("FmtOnSave", {})

vim.api.nvim_create_autocmd("BufWritePre", {
  group = fmt_on_save,
  pattern = {
    "*.css",
    "*.scss",
    "*.md",
    "*.go",
    "*.yaml",
    "*.yml",
    "*.json",
    "*.lua",
  },
  callback = function()
    vim.lsp.buf.formatting_sync({}, 3000)
  end,
})

-- format with eslint only for Gatsby repo
vim.api.nvim_create_autocmd("BufWritePre", {
  group = fmt_on_save,
  pattern = {
    "*.js",
    "*.ts",
    "*.jsx",
    "*.tsx",
  },
  callback = function()
    local p = vim.fn.expand("%:p")
    if string.match(p, "Gatsby/repo") then
      print("Formatting with Eslint")
      fmt_select.formatting_sync_select("eslint", {}, 3000)
    else
      print("Formatting with Prettier and Eslint")
      vim.lsp.buf.formatting_seq_sync({}, 3000, { "null-ls", "eslint" })
    end
  end,
})
