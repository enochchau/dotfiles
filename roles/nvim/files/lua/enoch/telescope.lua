local telescope = require "telescope"
local builtin = require "telescope.builtin"
local themes = require "telescope.themes"
local actions = require "telescope.actions"
local nmap = require("enoch.helpers").nmap

local function cursor_theme()
    local base = themes.get_dropdown()
    base.layout_strategy = "cursor"
    return base
end

telescope.setup {
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
        },
        ["ui-select"] = { cursor_theme() },
        pickers = {
            buffers = { mappings = { n = { dd = actions.delete_buffer } } },
        },
    },
}

telescope.load_extension "fzf"
telescope.load_extension "ui-select"
telescope.load_extension "node-workspace"

nmap("<C-p>", builtin.find_files)
nmap("<C-f>", builtin.live_grep)
nmap("<C-b>", builtin.buffers)
nmap("<leader>fh", builtin.help_tags)
nmap("z=", builtin.spell_suggest)
nmap("<leader>cdg", ":Telescope node-workspace<CR>")
