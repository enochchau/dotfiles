nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>
lua <<EOF
require'nvim-tree'.setup {
  view = {
    side = 'right',
    auto_resize = true
  }
}
EOF
