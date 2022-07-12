local neotree = require("neo-tree")
local nnoremap = require("enoch.helpers").nnoremap

vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

neotree.setup({
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
})

nnoremap("<leader>n", ":Neotree reveal<CR>")
nnoremap("<C-n>", ":Neotree toggle<CR>")
