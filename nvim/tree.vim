nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <leader>r :NvimTreeRefresh<CR>
nnoremap <leader>n :NvimTreeFindFile<CR>
let g:nvim_tree_ignore = ['.DS_Store']
lua <<EOF
require'nvim-tree'.setup {
  open_on_setup = true,
  view = {
    side = 'right',
    auto_resize = true
  }
}
EOF
