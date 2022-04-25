(local indent-blankline (require :indent_blankline))

(indent-blankline.setup {:space_char_blankline " " :show_current_context true})
(tset vim.g :indentLine_fileTypeExclude [:alpha])
