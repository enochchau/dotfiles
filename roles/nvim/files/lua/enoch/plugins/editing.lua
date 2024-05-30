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
        -- opts = { enable_autocmd = false },
    },
    -- {
    --     "numToStr/Comment.nvim",
    --     config = function()
    --         require("Comment").setup {
    --             pre_hook = require(
    --                 "ts_context_commentstring.integrations.comment_nvim"
    --             ).create_pre_hook(),
    --         }
    --     end,
    --     lazy = false,
    -- },
    {
        "danymat/neogen",
        dependencies = "nvim-treesitter/nvim-treesitter",
        config = true,
    },
    {
        "Darazaki/indent-o-matic",
        config = true,
        dependencies = { "nvim-treesitter/nvim-treesitter" },
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
            "rafamadriz/friendly-snippets",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local luasnip = require "luasnip"
            local lspkind = require "lspkind"
            local cmp = require "cmp"

            local function has_words_before()
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0
                    and vim.api
                            .nvim_buf_get_lines(0, line - 1, line, true)[1]
                            :sub(col, col)
                            :match "%s"
                        == nil
            end

            local function has_words_before_prompt()
                if vim.bo[0].buftype == "prompt" then
                    return false
                end
                return has_words_before()
            end

            cmp.setup.cmdline("/", {
                sources = { { name = "buffer" } },
                mapping = cmp.mapping.preset.cmdline(),
            })

            cmp.setup.cmdline(":", {
                sources = cmp.config.sources(
                    { { name = "path" } },
                    { { name = "cmdline" } }
                ),
                mapping = cmp.mapping.preset.cmdline(),
            })

            cmp.setup {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = {
                    ["<Tab>"] = cmp.mapping(
                        vim.schedule_wrap(function(fallback)
                            if cmp.visible() and has_words_before_prompt() then
                                cmp.select_next_item {
                                    behavior = cmp.SelectBehavior.Select,
                                }
                            elseif luasnip.expand_or_jumpable() then
                                luasnip.expand_or_jump()
                            elseif has_words_before() then
                                cmp.complete()
                            else
                                fallback()
                            end
                        end),
                        { "i", "s" }
                    ),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<CR>"] = cmp.mapping.confirm { select = true },
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

            require("luasnip.loaders.from_vscode").lazy_load()
        end,
    },
}
