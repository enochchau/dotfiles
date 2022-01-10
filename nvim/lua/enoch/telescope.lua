local helpers = require 'enoch.helpers'
local telescope = require('telescope')
local actions = require "telescope.actions"

telescope.setup({
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true
    }
  },
  pickers = {
    buffers = {
      mappings = {
        n = {
          ["dd"] = actions.delete_buffer
        }
      }
    }
  }
})
telescope.load_extension('fzf')
helpers.nnoremap('<C-p>', '<cmd>Telescope find_files<CR>')
helpers.nnoremap('<C-f>', '<cmd>Telescope live_grep<cr>')
helpers.nnoremap('<C-b>', '<cmd>Telescope buffers<cr>')
helpers.nnoremap('<leader>fh', '<cmd>Telescope help_tags<cr>')
