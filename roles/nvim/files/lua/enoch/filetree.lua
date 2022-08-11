local neotree = require "neo-tree"
local nmap = require("enoch.helpers").nmap

vim.cmd [[ let g:neo_tree_remove_legacy_commands = 1 ]]

neotree.setup {
    window = {
        position = "right",
        width = 35,
        mappings = {
            ["S"] = "split_with_window_picker",
            ["s"] = "vsplit_with_window_picker",
            ["<cr>"] = "open_with_window_picker",
        },
    },
    filesystem = {
        filtered_items = {
            visible = true,
        },
        never_show = {
            ".DS_Store",
        },
    },
}

nmap("<leader>n", ":Neotree reveal<CR>")
nmap("<C-n>", ":Neotree toggle<CR>")
