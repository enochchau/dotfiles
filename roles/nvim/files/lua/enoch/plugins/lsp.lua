local function config()
    local lspconfig = require "lspconfig"
    local mason = require "mason"
    local mason_lspconfig = require "mason-lspconfig"

    mason.setup()
    mason_lspconfig.setup()

    local signs = {
        Error = "󰅚 ", -- x000f015a
        Warn = "󰀪 ", -- x000f002a
        Info = "󰋽 ", -- x000f02fd
        Hint = "󰌶 ", -- x000f0336
    }

    for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end

    vim.diagnostic.config { virtual_text = false }

    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
            local client = vim.lsp.get_client_by_id(ev.data.client_id)
            local map = vim.keymap.set
            local map_opts = { noremap = true, silent = true, buffer = ev.buf }
            local supports = client.supports_method

            vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

            local fzf = require "fzf-lua"
            if supports "textDocument/rename" then
                map("n", "<leader>rn", vim.lsp.buf.rename, map_opts)
            end
            if supports "textDocument/definition" then
                map("n", "gd", fzf.lsp_definitions, map_opts)
            end
            if supports "textDocument/implementation" then
                map("n", "gi", fzf.lsp_implementations, map_opts)
            end
            if supports "textDocument/typeDefinition" then
                map("n", "gy", fzf.lsp_typedefs, map_opts)
            end
            if supports "textDocument/references" then
                map("n", "gr", fzf.lsp_references, map_opts)
            end
            if supports "textDocument/documentSymbol" then
                map("n", "gs", fzf.lsp_document_symbols, map_opts)
            end
            if supports "textDocument/diagnostic" then
                map("n", "ga", fzf.diagnostics_document, map_opts)
                map("n", "gw", fzf.diagnostics_workspace, map_opts)
            end
            if supports "textDocument/codeAction" then
                map("n", "<leader>a", vim.lsp.buf.code_action, map_opts)
                map(
                    "x",
                    "<leader>a",
                    ":<C-U>lua vim.lsp.buf.range_code_action()<CR>",
                    map_opts
                )
            end
        end,
    })

    local server_opts = {
        jsonls = {
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
            settings = {
                json = {
                    schemas = require("schemastore").json.schemas(),
                    validate = { enable = true },
                },
            },
        },
        yamlls = {
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
            settings = {
                yaml = {
                    schemaStore = {
                        -- You must disable built-in schemaStore support if you want to use
                        -- this plugin and its advanced options like `ignore`.
                        enable = false,
                        -- Avoid TypeError: Cannot read properties of undefined (reading 'length')
                        url = "",
                    },
                    schemas = require("schemastore").yaml.schemas(),
                },
            },
        },
        tsserver = {
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
            --- Settings for typescript-language-server, not tsserver
            -- init_options = {
            --     maxTsServerMemory = 4096,
            --     npmLocation = "npm",
            -- },
            -- settings = {
            --     typescript = {
            --         inlayHints = {
            --             includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all'
            --             includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            --             includeInlayVariableTypeHints = true,
            --             includeInlayFunctionParameterTypeHints = true,
            --             includeInlayVariableTypeHintsWhenTypeMatchesName = true,
            --             includeInlayPropertyDeclarationTypeHints = true,
            --             includeInlayFunctionLikeReturnTypeHints = true,
            --             includeInlayEnumMemberValueHints = true,
            --         },
            --     },
            --     javascript = {
            --         inlayHints = {
            --             includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all'
            --             includeInlayParameterNameHintsWhenArgumentMatchesName = true,
            --             includeInlayVariableTypeHints = true,
            --
            --             includeInlayFunctionParameterTypeHints = true,
            --             includeInlayVariableTypeHintsWhenTypeMatchesName = true,
            --             includeInlayPropertyDeclarationTypeHints = true,
            --             includeInlayFunctionLikeReturnTypeHints = true,
            --             includeInlayEnumMemberValueHints = true,
            --         },
            --     },
            -- },
        },
    }

    ---@type string[]
    local servers = vim.tbl_filter(function(server)
        return server ~= "tsserver"
    end, mason_lspconfig.get_installed_servers())


    -- setup
    require("typescript-tools").setup(server_opts.tsserver)
    for _, server in ipairs(servers) do
        local opts = server_opts[server]
            or {

                capabilities = require("cmp_nvim_lsp").default_capabilities(),
            }

        lspconfig[server].setup(opts)
    end
end

---@type LazySpec
return {
    {
        "neovim/nvim-lspconfig",
        config = config,
        dependencies = {
            "b0o/schemastore.nvim",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/nvim-cmp",
            "ibhagwan/fzf-lua",
            "pmizio/typescript-tools.nvim",
        },
    },
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    },
}
