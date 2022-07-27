local neotree = require "neo-tree"
local nmap = require("enoch.helpers").nmap

vim.cmd [[ let g:neo_tree_remove_legacy_commands = 1 ]]

neotree.setup {
    window = {
        position = "right",
        width = 35,
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
