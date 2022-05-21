local telescope = require("telescope")
local builtin = require("telescope.builtin")
local themes = require("telescope.themes")
local actions = require("telescope.actions")
local nnoremap = require("enoch.helpers").nnoremap

local function cursor_theme()
  local base = themes.get_dropdown()
  base.layout_strategy = "cursor"
  return base
end

telescope.setup({
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
})

telescope.load_extension("fzf")
telescope.load_extension("ui-select")

nnoremap("<C-p>", builtin.find_files)
nnoremap("<C-f>", builtin.live_grep)
nnoremap("<C-b>", builtin.buffers)
nnoremap("<leader>fh", builtin.help_tags)
