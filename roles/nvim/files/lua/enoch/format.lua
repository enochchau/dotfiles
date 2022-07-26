local fmt_select = require("nvim-format-select")
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local function fmt_eslint()
  fmt_select.formatting_sync_select("eslint", {}, 3000)
end

local function fmt_js()
  local path = vim.fn.expand("%:p")
  -- if string.match(path, "Gatsby/repo") then
  --   fmt_eslint()
  -- else
  vim.lsp.buf.formatting_seq_sync({}, 3000, { "null-ls", "eslint" })
  -- end
end

local function fmt_default()
  vim.lsp.buf.formatting_sync({}, 3000)
end

local fmt_on_save = augroup("FmtOnSave", {})
autocmd("BufWritePre", {
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
    "*.fnl",
  },
  callback = fmt_default,
})

autocmd("BufWritePre", {
  group = fmt_on_save,
  pattern = { "*.js", "*.ts", "*.jsx", "*.tsx", "*.cjs", "*.mjs" },
  callback = fmt_js,
})
