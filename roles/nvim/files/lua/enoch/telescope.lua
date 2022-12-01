local telescope = require "telescope"
local actions = require "telescope.actions"
local themes = require "telescope.themes"

telescope.setup {
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
        },
        ["ui-select"] = {
            themes.get_cursor(),
        },
    },
    pickers = {
        buffers = {
            mappings = { n = { dd = actions.delete_buffer } },
        },
    },
}

telescope.load_extension "fzf"
telescope.load_extension "ui-select"
telescope.load_extension "node-workspace"
