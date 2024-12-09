local prettier_fmt = { "prettierd", "prettier" }

---@type (string | LazySpec)[]
return {
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = { check_ts = true },
    },
    {
        "kylechui/nvim-surround",
        version = "*",
        event = "VeryLazy",
        config = true,
    },
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "black" },
                javascript = { prettier_fmt },
                typescript = { prettier_fmt },
                typescriptreact = { prettier_fmt },
                javascriptreact = { prettier_fmt },
                css = { prettier_fmt },
                scss = { prettier_fmt },
                less = { prettier_fmt },
                html = { prettier_fmt },
                json = { prettier_fmt },
                jsonc = { prettier_fmt },
                yaml = { prettier_fmt },
                markdown = { prettier_fmt },
                ["markdown.mdx"] = { prettier_fmt },
                graphql = { prettier_fmt },
                handlebars = { prettier_fmt },
                bash = { "beautysh", "shellcheck" },
                sh = { "beautysh", "shellcheck" },
                zsh = { "beautysh" },
            },
        },
        keys = {
            {
                "<leader>f",
                function()
                    require("conform").format({
                        async = true,
                        lsp_format = "fallback",
                    })
                end,
                mode = "",
                noremap = true,
                desc = "Format buffer",
            },
        },
        dependencies = { "williamboman/mason.nvim" },
    },
    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        opts = { enable_autocmd = false },
    },
    {
        "numToStr/Comment.nvim",
        dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
        config = function()
            require("Comment").setup({
                pre_hook = require(
                    "ts_context_commentstring.integrations.comment_nvim"
                ).create_pre_hook(),
            })
        end,
        lazy = false,
    },
    {
        "danymat/neogen",
        config = true,
    },
    {
        "Darazaki/indent-o-matic",
        config = true,
    },

    {
        "L3MON4D3/LuaSnip",
        -- follow latest release.
        version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
        -- install jsregexp (optional!).
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    },
    {
        "saghen/blink.cmp",
        lazy = false,
        dependencies = "rafamadriz/friendly-snippets",
        version = "v0.7.4",

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            keymap = { preset = "super-tab" },
            completion = {
                documentation = {
                    auto_show = true,
                },
            },
        },
        opts_extend = { "sources.completion.enabled_providers" },
    },
}
