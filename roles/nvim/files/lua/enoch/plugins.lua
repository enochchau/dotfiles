---@type (string | LazySpec)[]
local plugins = {
    -- editing
    "tpope/vim-obsession",
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        config = true,
    },
    {
        "Darazaki/indent-o-matic",
        config = true,
        dependencies = { "nvim-treesitter/nvim-treesitter" },
    },

    -- themes
    "navarasu/onedark.nvim",
    "folke/tokyonight.nvim",

    { "j-hui/fidget.nvim", opts = {} },

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
        main = "ibl",
        opts = {},
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("ibl").setup {
                indent = { char = "│" },
                scope = {
                    enabled = true,
                    show_start = false,
                    show_end = false,
                },
                exclude = { filetypes = { "alpha" } },
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

    -- Editing
    {
        "danymat/neogen",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = true,
    },
    "JoosepAlviste/nvim-ts-context-commentstring",
    {
        "echasnovski/mini.comment",
        version = "*",
        opts = {
            options = {
                custom_commentstring = function()
                    return require("ts_context_commentstring").calculate_commentstring()
                        or vim.bo.commentstring
                end,
            },
        },
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = { check_ts = true },
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
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "black" },
                javascript = { { "prettierd", "prettier" } },
                typescript = { { "prettierd", "prettier" } },
                typescriptreact = { { "prettierd", "prettier" } },
                javascriptreact = { { "prettierd", "prettier" } },
                astro = { { "prettierd", "prettier" } },
                json = { { "prettierd", "prettier" } },
                yaml = { { "prettierd", "prettier" } },
            },
        },
        keys = {
            {
                "<leader>f",
                function()
                    require("conform").format {
                        async = true,
                        lsp_fallback = true,
                    }
                end,
                mode = "",
                desc = "Format buffer",
            },
        },
    },
}

return plugins
