local has_termux = vim.env["TERMUX"] ~= nil

---@type (string | LazyPlugin)[]
local plugins = {
    {
        "kylechui/nvim-surround",
        config = function()
            require("nvim-surround").setup {}
        end,
    },
    -- editing
    "tpope/vim-obsession",
    {
        "Darazaki/indent-o-matic",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("indent-o-matic").setup {}
        end,
    },
    "gpanders/editorconfig.nvim",

    -- themes
    "savq/melange-nvim",
    {
        "marko-cerovac/material.nvim",
        config = function()
            vim.g.material_style = "palenight"
            vim.cmd.colorscheme "material"
            vim.opt.bg = "dark"
        end,
    },
    "navarasu/onedark.nvim",
    "NTBBloodbath/doom-one.nvim",
    "folke/tokyonight.nvim",
    "kaiuri/nvim-juliana",
    { "EdenEast/nightfox.nvim", build = ":NightfoxCompile" },
    "rebelot/kanagawa.nvim",

    {
        "vigoux/notifier.nvim",
        config = function()
            require("notifier").setup {}
        end,
    },

    -- markdown
    -- code block syntax highlighting
    {
        "AckslD/nvim-FeMaco.lua",
        ft = { "markdown" },
        config = function()
            require("femaco").setup()
        end,
    },
    {
        "iamcco/markdown-preview.nvim",
        enabled = not has_termux,
        ft = { "markdown" },
        run = "cd app && yarn install",
        cmd = { "MarkdownPreviewToggle" },
        config = function()
            vim.keymap.set(
                "n",
                "<CR>",
                ":MarkdownPreviewToggle<CR>",
                { noremap = true, silent = true }
            )
        end,
    },

    -- mjml
    "amadeus/vim-mjml",
    {
        "ec965/mjml-preview.nvim",
        enabled = not has_termux,
        ft = { "mjml" },
        build = "cd app && npm install",
        cmd = { "MjmlPreviewToggle" },
        config = function()
            vim.keymap.set(
                "n",
                "<CR>",
                ":MjmlPreviewToggle<CR>",
                { noremap = true, silent = true }
            )
        end,
    },

    -- additional language support
    "pearofducks/ansible-vim",

    -- qol
    {
        "almo7aya/openingh.nvim",
        cmd = { "OpenInGHFile", "OpenInGHRepo" },
        config = function()
            require("openingh").setup()
        end,
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
        "nvim-treesitter/playground",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        cmd = "TSPlaygroundToggle",
    },
    {
        "danymat/neogen",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = true,
    },
}
return plugins
