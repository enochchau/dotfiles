local helpers = require 'enoch.helpers'

require'nvim-tree'.setup {
  open_on_setup = false,
  update_cwd = true,
  view = {
    side = 'right',
    auto_resize = true,
    width = 35,
    relativenumber = true,
    signcolumn = 'auto'
  },
  git = {
    enable = true,
    ignore = false,
  },
  filters = {
    custom = {
      '.DS_Store'
    }
  }
}

helpers.nnoremap('<leader>n', ':NvimTreeFindFile<CR>')
helpers.nnoremap('<C-n>', ':NvimTreeToggle<CR>')
helpers.nnoremap('<leader>r', ':NvimTreeRefresh<CR>')
