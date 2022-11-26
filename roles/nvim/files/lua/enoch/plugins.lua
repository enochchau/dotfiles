return require("packer").startup(function(use)
    local has_termux = vim.env["TERMUX"] ~= nil
    local dev = not has_termux

    --- Format my plugin's config to use local or remote
    ---@param config table|string
    ---@return table|string
    local function d(config)
        local function configure_path(plugin_name)
            if dev then
                return "~/code/" .. plugin_name
            else
                return "ec965/" .. plugin_name
            end
        end

        if type(config) == "string" then
            return configure_path(config)
        else
            config[1] = configure_path(config[1])
            return config
        end
    end

    use "wbthomason/packer.nvim"

    -- editing
    use "tpope/vim-obsession"
    use {
        "nmac427/guess-indent.nvim",
        config = function()
            require("guess-indent").setup {}
        end,
    }
    use "tpope/vim-surround"
    use "gpanders/editorconfig.nvim"

    -- themes
    use "navarasu/onedark.nvim"
    use "NTBBloodbath/doom-one.nvim"
    use "folke/tokyonight.nvim"
    use "kaiuri/nvim-juliana"
    use { "EdenEast/nightfox.nvim", run = ":NightfoxCompile" }

    -- yarn pnp
    use {
        "lbrayner/vim-rzip",
        ft = {
            "javascript",
            "typescript",
            "typescriptreact",
            "javascriptreact",
        },
        config = function()
            vim.cmd "source ~/.config/nvim/rzip.vim"
        end,
    }
    use(d "nvim-pnp-checker")

    -- lsp
    use {
        "neovim/nvim-lspconfig",
        config = function()
            require "enoch.lsp"
        end,
        requires = {
            "jose-elias-alvarez/null-ls.nvim",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "b0o/schemastore.nvim",
            "onsails/lspkind.nvim",
            "jayp0521/mason-null-ls.nvim",
        },
    }

    use {
        "vigoux/notifier.nvim",
        config = function()
            require("notifier").setup {}
        end,
    }

    -- completion
    use {
        "hrsh7th/nvim-cmp",
        config = function()
            require "enoch.cmp"
        end,
        requires = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "f3fora/cmp-spell",
            -- snippets
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
    }

    -- fuzzy finder
    use {
        "nvim-telescope/telescope.nvim",
        config = function()
            require "enoch.telescope"
        end,
        requires = {
            "nvim-lua/plenary.nvim",
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                run = "make",
            },
            "nvim-telescope/telescope-ui-select.nvim",
        },
    }
    use(d "telescope-node-workspace.nvim")

    -- tree sitter
    use {
        "nvim-treesitter/nvim-treesitter",
        config = function()
            require "enoch.treesitter"
        end,
        run = ":TSUpdate",
        requires = {
            "numToStr/Comment.nvim",
            {
                "windwp/nvim-autopairs",
                config = function()
                    require("nvim-autopairs").setup { check_ts = true }
                end,
            },
            "windwp/nvim-ts-autotag",
            "JoosepAlviste/nvim-ts-context-commentstring",
            {
                "danymat/neogen",
                config = function()
                    require("neogen").setup {}
                    require("enoch.helpers").nmap(
                        "<leader>nf",
                        require("neogen").generate
                    )
                end,
            },
            "nvim-treesitter/nvim-treesitter-context",
        },
    }

    -- markdown
    -- code block syntax highlighting
    use {
        "AckslD/nvim-FeMaco.lua",
        ft = "markdown",
        config = function()
            require("femaco").setup()
        end,
    }

    if not has_termux then
        use {
            "iamcco/markdown-preview.nvim",
            ft = { "markdown" },
            run = "cd app && yarn install",
            config = function()
                require("enoch.helpers").nmap(
                    "<CR>",
                    ":MarkdownPreviewToggle<CR>"
                )
            end,
        }
    end

    -- mjml
    use "amadeus/vim-mjml"
    if not has_termux then
        use(d {
            "mjml-preview.nvim",
            ft = "mjml",
            run = "cd app && npm install",
            config = function()
                require("enoch.helpers").nmap("<CR>", ":MjmlPreviewToggle<CR>")
            end,
        })
    end

    -- additional language support
    use "pearofducks/ansible-vim"
    use "vim-crystal/vim-crystal"

    -- status line
    use {
        "nvim-lualine/lualine.nvim",
        config = function()
            require "enoch.statusline"
        end,
    }

    -- qol
    use {
        "almo7aya/openingh.nvim",
        config = function()
            require("openingh").setup()
        end,
    }
    use {
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
    }
    use {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup { current_line_blame = true }
        end,
    }
    use {
        "goolord/alpha-nvim",
        config = function()
            require "enoch.alpha"
        end,
    }
    use {
        "numToStr/FTerm.nvim",
        config = function()
            require "enoch.term"
        end,
    }
    use {
        "ggandor/leap.nvim",
        config = function()
            require("leap").set_default_keymaps()
        end,
    }
    use {
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
    }

    -- make vim start faster
    use "lewis6991/impatient.nvim"

    -- file tree
    use {
        "kyazdani42/nvim-tree.lua",
        requires = { "kyazdani42/nvim-web-devicons" },
        config = function()
            require "enoch.filetree"
        end,
    }

    -- window picker
    use {
        "https://gitlab.com/yorickpeterse/nvim-window.git",
        config = function()
            local nvim_window = require "nvim-window"
            nvim_window.setup {
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
            require("enoch.helpers").nmap("<leader>w", function()
                nvim_window.pick()
            end)
        end,
    }
end)
