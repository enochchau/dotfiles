---@type (string | LazySpec)[]
local plugins = {
    -- { "zbirenbaum/copilot.lua", config = true },

    -- editing
    "tpope/vim-obsession",

    -- themes
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        opts = {
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
        },
    },
    "navarasu/onedark.nvim",
    "folke/tokyonight.nvim",
    "nyoom-engineering/oxocarbon.nvim",

    -- additional language support
    "pearofducks/ansible-vim",
    "vim-scripts/applescript.vim",
    "amadeus/vim-mjml",

    -- qol
    {
        "almo7aya/openingh.nvim",
        cmd = { "OpenInGHFile", "OpenInGHRepo" },
        config = true,
    },

    "tpope/vim-eunuch",

    -- window picker
    {
        url = "https://gitlab.com/yorickpeterse/nvim-window.git",
        opts = {
            -- stylua: ignore
            chars = {
                "f", "j", "d", "k", "s", "l", "a", ";", "c", "m", "r", "u", "e", "i", "w", "o", "q", "p",
            },
        },
        keys = {
            {

                "<leader>w",
                function()
                    (require("nvim-window")).pick()
                end,
                mode = "",
                desc = "Pick window",
                noremap = true,
            },
        },
    },

    {
        "williamboman/mason.nvim",
        config = true,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = true,
        dependencies = { "williamboman/mason.nvim" },
    },
    {
        "OXY2DEV/markview.nvim",
        lazy = false,
    },
    {
        "OXY2DEV/helpview.nvim",
        lazy = false,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
    },
}

return plugins
