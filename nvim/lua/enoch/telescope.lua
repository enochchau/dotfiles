local helpers = require'enoch.helpers'
local telescope = require('telescope')

telescope.load_extension('fzf')
telescope.setup()
helpers.nnoremap('<C-p>', '<cmd>Telescope find_files<CR>')
helpers.nnoremap('<C-f>', '<cmd>Telescope live_grep<cr>')
helpers.nnoremap('<C-b>', '<cmd>Telescope buffers<cr>')
helpers.nnoremap('<leader>fh', '<cmd>Telescope help_tags<cr>')
