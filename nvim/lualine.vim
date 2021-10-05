lua <<EOF
require('lualine').setup{
  sections = {
    lualine_b = {'g:coc_git_status', 'b:coc_git_status', 'b:coc_git_blame', 'g:coc_status' }
  },
  options = {
    theme = 'solarized'
  }
}
EOF
