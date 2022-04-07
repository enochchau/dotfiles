vim.g.indentLine_fileTypeExclude = { "alpha" }
require("indent_blankline").setup({
  space_char_blankline = " ",
  show_current_context = true,
})
