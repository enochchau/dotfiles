---@type (string | LazySpec)[]
local plugins = {
    {
        "enochchau/nvim-pretty-ts-errors",
        -- "nvim-pretty-ts-errors",
        -- dir = "~/code/nvim-pretty-ts-errors",
        build = "pnpm install",
    },

    -- editing
    "tpope/vim-obsession",

    -- themes
    {
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        opts = {
            lsp_styles = {
                underlines = {
                    errors = { "undercurl" },
                    hints = { "undercurl" },
                    warnings = { "undercurl" },
                    information = { "undercurl" },
                },
            },
        },
    },

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
        "mason-org/mason.nvim",
        config = true,
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            -- your configuration comes here
            -- or leave it empty to use the default settings
            -- refer to the configuration section below
        },
        keys = {
            {
                "<leader>?",
                function()
                    require("which-key").show({ global = false })
                end,
                desc = "Buffer Local Keymaps (which-key)",
            },
        },
}
}

return plugins
