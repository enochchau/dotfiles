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
                javascript = { "prettierd", "prettier" },
                typescript = { "prettierd", "prettier" },
                typescriptreact = { "prettierd", "prettier" },
                javascriptreact = { "prettierd", "prettier" },
                css = { "prettierd", "prettier" },
                scss = { "prettierd", "prettier" },
                less = { "prettierd", "prettier" },
                html = { "prettierd", "prettier" },
                json = { "prettierd", "prettier" },
                jsonc = { "prettierd", "prettier" },
                yaml = { "prettierd", "prettier" },
                markdown = { "prettierd", "prettier" },
                ["markdown.mdx"] = { "prettierd", "prettier" },
                ["mdx"] = { "prettierd", "prettier" },
                graphql = { "prettierd", "prettier" },
                handlebars = { "prettierd", "prettier" },
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
    {
        "lewis6991/gitsigns.nvim",
    },
}
