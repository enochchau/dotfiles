return {
    "nvim-treesitter/nvim-treesitter",
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
    config = function()
        local langs = {
            "astro",
            "bash",
            "c",
            "comment",
            "cpp",
            "css",
            "dockerfile",
            "dot",
            "fennel",
            "go",
            "gomod",
            "gowork",
            "graphql",
            "hcl",
            "help",
            "html",
            "javascript",
            "jsdoc",
            "json",
            "jsonc",
            "julia",
            "lua",
            "make",
            "markdown",
            "markdown_inline",
            "prisma",
            "python",
            "query",
            "regex",
            "regex",
            "rust",
            "scss",
            "sql",
            "svelte",
            "toml",
            "tsx",
            "typescript",
            "vim",
            "yaml",
            "zig",
        }

        require("nvim-treesitter.configs").setup {
            ensure_installed = langs,
            sync_install = false,
            playground = { enable = true },
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            autotag = {
                enable = true,
                filetypes = {
                    "astro",
                    "glimmer",
                    "handlebars",
                    "hbs",
                    "html",
                    "javascript",
                    "javascriptreact",
                    "jsx",
                    "markdown",
                    "php",
                    "rescript",
                    "svelte",
                    "tsx",
                    "typescript",
                    "typescriptreact",
                    "vue",
                    "xml",
                },
            },
            context_commentstring = {
                enable = true,
                enable_autocmd = false,
            },
        }

        require("Comment").setup {
            ignore = "^$",
            pre_hook = function(ctx)
                local U = require "Comment.utils"

                local location = nil
                if ctx.ctype == U.ctype.block then
                    location =
                        require("ts_context_commentstring.utils").get_cursor_location()
                elseif
                    ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V
                then
                    location =
                        require("ts_context_commentstring.utils").get_visual_start_location()
                end

                return require("ts_context_commentstring.internal").calculate_commentstring {
                    key = ctx.ctype == U.ctype.linewise and "__default"
                        or "__multiline",
                    location = location,
                }
            end,
        }

        require("treesitter-context").setup()

        require("nvim-autopairs").setup { check_ts = true }
        require("neogen").setup {}
    end,
}
