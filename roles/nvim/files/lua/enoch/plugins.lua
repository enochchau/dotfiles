local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system {
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    }
end
vim.opt.runtimepath:prepend(lazypath)

require("lazy").setup {

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

    -- lsp
    {
        "neovim/nvim-lspconfig",
        config = function()
            require "enoch.lsp"
        end,
        dependencies = {
            "jose-elias-alvarez/null-ls.nvim",
            "williamboman/mason.nvim",
            "b0o/schemastore.nvim",
            "onsails/lspkind.nvim",
        },
    },
    {
        "vigoux/notifier.nvim",
        config = function()
            require("notifier").setup {}
        end,
    },

    -- completion
    {
        "hrsh7th/nvim-cmp",
        config = function()
            require "enoch.cmp"
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "f3fora/cmp-spell",
            -- snippets
            "L3MON4D3/LuaSnip",
            "rafamadriz/friendly-snippets",
            "saadparwaiz1/cmp_luasnip",
        },
    },

    -- fuzzy finder
    {
        "ibhagwan/fzf-lua",
        config = function()
            require("fzf-lua").register_ui_select()
        end,
    },

    -- tree sitter
    {
        "nvim-treesitter/nvim-treesitter",
        config = function()
            require("nvim-autopairs").setup { check_ts = true }
            require("neogen").setup {}
            require "enoch.treesitter"
        end,
        build = ":TSUpdate",
        dependencies = {
            "nvim-treesitter/playground",
            "numToStr/Comment.nvim",
            "windwp/nvim-autopairs",
            "windwp/nvim-ts-autotag",
            "JoosepAlviste/nvim-ts-context-commentstring",
            "danymat/neogen",
            "nvim-treesitter/nvim-treesitter-context",
        },
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
    { "vim-crystal/vim-crystal" },

    -- status line
    {
        "nvim-lualine/lualine.nvim",
        config = function()
            require "enoch.statusline"
        end,
    },

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
        "goolord/alpha-nvim",
        config = function()
            require "enoch.alpha"
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
