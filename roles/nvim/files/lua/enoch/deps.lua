-- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
local path_package = vim.fn.stdpath("data") .. "/site/"
local mini_path = path_package .. "pack/deps/start/mini.nvim"
if not vim.loop.fs_stat(mini_path) then
    vim.cmd('echo "Installing `mini.nvim`" | redraw')
    local clone_cmd = {
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/nvim-mini/mini.nvim",
        mini_path,
    }
    vim.fn.system(clone_cmd)
    vim.cmd("packadd mini.nvim | helptags ALL")
    vim.cmd('echo "Installed `mini.nvim`" | redraw')
end

-- Set up 'mini.deps' (customize to your liking)
require("mini.deps").setup({ path = { package = path_package } })
local add = MiniDeps.add
local map = vim.keymap.set

add("tpope/vim-obsession")

add("catppuccin/nvim")
require("catppuccin").setup({
    integrations = {
        native_lsp = {
            underlines = {
                errors = { "undercurl" },
                hints = { "undercurl" },
                warnings = { "undercurl" },
                information = { "undercurl" },
                ok = { "undercurl" },
            },
        },
    },
})

add("pearofducks/ansible-vim")
add("vim-scripts/applescript.vim")
add("amadeus/vim-mjml")

add("almo7aya/openingh.nvim")
require("openingh").setup()

add("tpope/vim-eunuch")

add("https://gitlab.com/yorickpeterse/nvim-window.git")
require("nvim-window").setup({
    -- stylua: ignore
    chars = {
        "f", "j", "d", "k", "s", "l", "a", ";", "c", "m", "r", "u", "e", "i", "w", "o", "q", "p",
    },
})
map("n", "<leader>w", function()
    require("nvim-window").pick()
end, { desc = "Pick window", noremap = true })

require("enoch.mplugins.ui")
require("enoch.mplugins.treesitter")
require("enoch.mplugins.lsp")
require("enoch.mplugins.picker")
require("enoch.mplugins.editing")
