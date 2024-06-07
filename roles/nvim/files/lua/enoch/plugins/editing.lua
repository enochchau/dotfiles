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
                    require("conform").format {
                        async = true,
                        lsp_fallback = true,
                    }
                end,
                mode = "",
                noremap = true,
                desc = "Format buffer",
            },
        },
    },
    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        opts = { enable_autocmd = false },
    },
    {
        "numToStr/Comment.nvim",
        dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
        config = function()
            require("Comment").setup {
                pre_hook = require(
                    "ts_context_commentstring.integrations.comment_nvim"
                ).create_pre_hook(),
            }
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
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "f3fora/cmp-spell",
            -- snippets
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
            "onsails/lspkind.nvim",
        },
        config = function()
            local luasnip = require "luasnip"
            local lspkind = require "lspkind"
            local cmp = require "cmp"

            cmp.setup {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = {
                    ["<CR>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            if luasnip.expandable() then
                                luasnip.expand()
                            else
                                cmp.confirm {
                                    select = true,
                                }
                            end
                        else
                            fallback()
                        end
                    end),

                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.locally_jumpable(1) then
                            luasnip.jump(1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.locally_jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                },
                sources = cmp.config.sources(
                    {
                        { name = "nvim_lsp" },
                        { name = "luasnip" },
                    },
                    { { name = "buffer" } },
                    { { name = "path" } },
                    { { name = "spell" } }
                ),
                formatting = {
                    format = lspkind.cmp_format {
                        preset = "default",
                        mode = "symbol_text",
                    },
                },
            }

            -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
            })

            -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    { name = "cmdline" },
                }),
                matching = { disallow_symbol_nonprefix_matching = false },
            })
        end,
    },
}
