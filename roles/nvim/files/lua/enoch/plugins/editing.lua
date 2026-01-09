local prettier_fmt = { "prettierd", "prettier" }

---@type (string | LazySpec)[]
return {
    { "nvim-mini/mini.pairs", version = false, config = true },
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
                python = { "ruff_format", "black" },
                javascript = prettier_fmt,
                typescript = prettier_fmt,
                typescriptreact = prettier_fmt,
                javascriptreact = prettier_fmt,
                css = prettier_fmt,
                scss = prettier_fmt,
                less = prettier_fmt,
                html = prettier_fmt,
                json = prettier_fmt,
                jsonc = prettier_fmt,
                yaml = prettier_fmt,
                markdown = prettier_fmt,
                ["markdown.mdx"] = prettier_fmt,
                ["mdx"] = prettier_fmt,
                graphql = prettier_fmt,
                handlebars = prettier_fmt,
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
                        stop_after_first = true,
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
        "folke/ts-comments.nvim",
        opts = {},
        event = "VeryLazy",
        enabled = vim.fn.has("nvim-0.10.0") == 1,
    },
    {
        "numToStr/Comment.nvim",
        lazy = false,
    },
    {
        "Darazaki/indent-o-matic",
        config = true,
    },

    {
        "saghen/blink.cmp",
        lazy = false,
        dependencies = { "rafamadriz/friendly-snippets" },
        version = "v1.*",

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
        opts_extend = { "sources.default" },
    },
}
