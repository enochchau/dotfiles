lua <<EOF
require('lualine').setup{
  sections = {
    lualine_b = {'g:coc_git_status', 'b:coc_git_status', 'b:coc_git_blame', 'g:coc_status' }
  },
  options = {
    theme = 'auto',
    section_separators = '',
    component_separators = '│',
  }
}
EOF
