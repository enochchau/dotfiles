return {
    -- editing
    "tpope/vim-obsession",
    {
        "nmac427/guess-indent.nvim",
        config = function()
            require("guess-indent").setup {}
        end,
    },
    { "tpope/vim-surround" },
    { "gpanders/editorconfig.nvim" },

    -- themes
    { "navarasu/onedark.nvim" },
    { "NTBBloodbath/doom-one.nvim" },
    { "folke/tokyonight.nvim" },
    { "kaiuri/nvim-juliana" },
    { "EdenEast/nightfox.nvim", build = ":NightfoxCompile" },
    { "rebelot/kanagawa.nvim" },

    -- yarn pnp
    { "ec965/nvim-pnp-checker" },

    {
        "vigoux/notifier.nvim",
        config = function()
            require("notifier").setup {}
        end,
    },

    -- fuzzy finder
    {
        "ibhagwan/fzf-lua",
        config = function()
            require("fzf-lua").register_ui_select()
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
    { "amadeus/vim-mjml" },
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
    { "pearofducks/ansible-vim" },


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
            vim.g.indent_blankline_filetype_exclude = {
                "alpha",
                "lspinfo",
                "packer",
                "checkhealth",
                "help",
                "man",
                "",
            }
            require("indent_blankline").setup {
                space_char_blankline = " ",
                show_current_context = true,
            }
        end,
    },
    {
        "NvChad/nvim-colorizer.lua",
        config = function()
            require("colorizer").setup {
                filetypes = {
                    "javascript",
                    "javascriptreact",
                    "svelte",
                    "astro",
                    "typescript",
                    "typescriptreact",
                    "css",
                    "scss",
                },
                user_default_options = {
                    names = false,
                    mode = "virtualtext",
                },
            }
        end,
        ft = {
            "javascript",
            "javascriptreact",
            "svelte",
            "astro",
            "typescript",
            "typescriptreact",
            "css",
            "scss",
        },
    },

    { "nvim-tree/nvim-web-devicons" },
    { "nvim-lua/plenary.nvim" },

    -- window picker
    {
        url = "https://gitlab.com/yorickpeterse/nvim-window.git",
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
        end,
    },
    { "ec965/fnlnvim" },
}
