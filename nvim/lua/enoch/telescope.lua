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
    find_files = {
      hidden = true,
      no_ignore = true
    },
    buffers = {
      mappings = {
        n = {
          ["dd"] = actions.delete_buffer + actions.move_to_top
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
