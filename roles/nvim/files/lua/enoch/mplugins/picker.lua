local add = MiniDeps.add
add("nvim-mini/mini.icons")
require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()

add({
    source = "nvim-mini/mini.pick",
    depends = {
        "nvim-mini/mini.icons",
        "nvim-mini/mini.extra",
    },
})

require("mini.pick").setup()
require("mini.extra").setup()
MiniIcons.mock_nvim_web_devicons()

local map = vim.keymap.set
local opts = { noremap = true, silent = true }
vim.ui.select = MiniPick.ui_select

map("n", "<C-p>", MiniPick.builtin.files, opts)
map("n", "<C-f>", MiniPick.builtin.grep_live, opts)
map("n", "<C-b>", MiniPick.builtin.buffers, opts)
map("n", "<leader>fh", MiniPick.builtin.help, opts)
map("n", "z=", MiniExtra.pickers.spellsuggest, opts)
map("n", "<leader>o", ":Pick list scope='jump'<CR>", opts)
map("n", "<leader>'", MiniExtra.pickers.marks, opts)
