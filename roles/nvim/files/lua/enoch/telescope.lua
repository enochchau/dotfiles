local telescope = require "telescope"
local themes = require "telescope.themes"
local actions = require "telescope.actions"

local function cursor_theme()
    local base = themes.get_dropdown()
    base.layout_strategy = "cursor"
    return base
end

telescope.load_extension "fzf"
telescope.load_extension "ui-select"
telescope.load_extension "node-workspace"

telescope.setup {
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
        },
        ["ui-select"] = { cursor_theme() },
    },
    pickers = {
        buffers = {
            mappings = { n = { dd = actions.delete_buffer } },
        },
    },
}
