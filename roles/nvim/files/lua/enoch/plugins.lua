local has_termux = vim.env["TERMUX"] ~= nil
---@type (string | LazyPlugin)[]
local plugins = {
    { "kylechui/nvim-surround", config = true },
    -- editing
    "tpope/vim-obsession",
    {
        "Darazaki/indent-o-matic",
        config = true,
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },

    -- themes
    "savq/melange-nvim",
    {
        "marko-cerovac/material.nvim",
        config = function()
            vim.g.material_style = "palenight"
        end,
    },
    "navarasu/onedark.nvim",
    "NTBBloodbath/doom-one.nvim",
    {
        "folke/tokyonight.nvim",
        config = function()
            vim.opt.bg = "light"
            vim.cmd.colorscheme "tokyonight"
        end,
    },
    "kaiuri/nvim-juliana",
    { "EdenEast/nightfox.nvim", build = ":NightfoxCompile" },
    "rebelot/kanagawa.nvim",

    { "vigoux/notifier.nvim", config = true },

    -- additional language support
    "pearofducks/ansible-vim",
    "amadeus/vim-mjml",

    -- qol
    {
        "almo7aya/openingh.nvim",
        cmd = { "OpenInGHFile", "OpenInGHRepo" },
        config = true,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            table.insert(vim.g.indent_blankline_filetype_exclude, "alpha")
            require("indent_blankline").setup {
                space_char_blankline = " ",
                show_current_context = true,
            }
        end,
    },
    "nvim-tree/nvim-web-devicons",
    "nvim-lua/plenary.nvim",

    -- window picker
    {
        url = "https://gitlab.com/yorickpeterse/nvim-window.git",
        keys = { "<leader>w" },
        config = function()
            require("nvim-window").setup {
                chars = {
                    "f",
                    "j",
                    "d",
                    "k",
                    "s",
                    "l",
                    "a",
                    ";",
                    "c",
                    "m",
                    "r",
                    "u",
                    "e",
                    "i",
                    "w",
                    "o",
                    "q",
                    "p",
                },
            }

            vim.keymap.set(
                "n",
                "<leader>w",
                (require "nvim-window").pick,
                { noremap = true, silent = true }
            )
        end,
    },
    { "ec965/fnlnvim", cmd = { "FnlNvimCompile", "FnlNvimEval" } },
    {
        "danymat/neogen",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = true,
    },

    -- copilot
    {
        "zbirenbaum/copilot.lua",
        config = function()
            require("copilot").setup {
                filetypes = { ocaml = false },
                suggestion = { enabled = false },
                panel = { enabled = false },
            }
        end,
    },
    {
        "zbirenbaum/copilot-cmp",
        config = function()
            require("copilot_cmp").setup()
        end,
    },

    {
        "NvChad/nvim-colorizer.lua",
        opts = {
            filetypes = {
                "javascript",
                "javascriptreact",
                "svelte",
                "astro",
                "html",
                "typescript",
                "typescriptreact",
                "css",
                "scss",
            },
            user_default_options = { mode = "virtualtext" },
        },
    },
}

return plugins
