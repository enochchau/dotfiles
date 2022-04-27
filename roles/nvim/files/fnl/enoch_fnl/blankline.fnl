(local indent-blankline (require :indent_blankline))

(indent-blankline.setup {:space_char_blankline " " :show_current_context true})

(set vim.g.indent_blankline_filetype_exclude
     [:alpha :lspinfo :packer :checkhealth :help :man ""])
