-- for project_nvim
vim.g.nvim_tree_respect_buf_cwd = 1

require("nvim-tree").setup({
  open_on_setup = false,
  update_cwd = true,
  view = {
    side = "right",
    auto_resize = true,
    width = 35,
    relativenumber = true,
    signcolumn = "auto",
  },
  git = {
    enable = true,
    ignore = false,
  },
  filters = {
    custom = {
      ".DS_Store",
    },
  },
})

local nnoremap = {
  ["<leader>n"] = ":NvimTreeFindFile<CR>",
  ["<C-n>"] = ":NvimTreeToggle<CR>",
  ["<leader>r"] = ":NvimTreeRefresh<CR>",
}

for lhs, rhs in pairs(nnoremap) do
  vim.api.nvim_set_keymap("n", lhs, rhs, { noremap = true, silent = true })
end
