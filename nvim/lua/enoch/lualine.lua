require('lualine').setup {
  sections = {
    lualine_b = {
      'branch',
      'b:gitsigns_status',
      {
        'diagnostics',
        sources = {
          'nvim_lsp',
          'coc'
        }
      }
    }
  },
  options = {
    theme = 'neon',
    section_separators = '',
    component_separators = '│'
  }
}