lua << EOF
require('lualine').setup{
  sections = {
    lualine_b = {'b:gitsigns_status', 'g:coc_status' }
  },
  options = {
    theme = 'onedark',
    section_separators = '',
    component_separators = '│',
  }
}
EOF
