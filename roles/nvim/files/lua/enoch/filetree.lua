local nvim_tree = require("nvim-tree")
local nnoremap = require("enoch.helpers").nnoremap

nvim_tree.setup({
  open_on_setup = false,
  update_cwd = true,
  view = {
    side = "right",
    width = 35,
    relativenumber = true,
    signcolumn = "auto",
  },
  git = {
    enable = true,
    ignore = false,
  },
  filters = {
    custom = { ".DS_Store" },
  },
})

nnoremap("<leader>n", ":NvimTreeFindFile<CR>")
nnoremap("<C-n>", ":NvimTreeToggle<CR>")
nnoremap("<leader>r", ":NvimTreeRefresh<CR>")
