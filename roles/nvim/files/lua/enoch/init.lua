local nnoremap = require("enoch.helpers").nnoremap
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

require("enoch.settings")
require("enoch.alpha")
require("enoch.cmp")
require("enoch.filetree")
require("enoch.format")
require("enoch.lsp")
require("enoch.statusline")
require("enoch.telescope")
require("enoch.term")
require("enoch.theme")
require("enoch.treesitter")

require("fidget").setup()
require("leap").set_default_keymaps()
require("gitsigns").setup({ current_line_blame = true })
require("nvim-autopairs").setup({ check_ts = true })
require("indent_blankline").setup({
  space_char_blankline = " ",
  show_current_context = true,
})
require("neogen").setup({})

vim.g.indent_blankline_filetype_exclude = {
  "alpha",
  "lspinfo",
  "packer",
  "checkhealth",
  "help",
  "man",
  "",
}

local comment_string = augroup("CommentString", {})
autocmd("FileType", {
  group = comment_string,
  pattern = { "fennel" },
  callback = function()
    vim.opt_local.commentstring = ";; %s"
  end,
})

nnoremap("<CR>", ":MarkdownPreviewToggle<CR>")

nnoremap("<leader>nf", require("neogen").generate)
