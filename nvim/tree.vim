nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>
lua <<EOF
require'nvim-tree'.setup {
  open_on_setup = true,
  update_cwd = true,
  view = {
    side = 'right',
    auto_resize = true,
    width = 35
  },
  filters = {
    custom = {'.DS_Store'}
  }
}
EOF
