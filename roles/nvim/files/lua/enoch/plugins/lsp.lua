local function config()
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
            local FzfLua = require("fzf-lua")
            local client = vim.lsp.get_client_by_id(ev.data.client_id)
            if client == nil then
                return
            end

            local map = vim.keymap.set
            local method = vim.lsp.protocol.Methods

            vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

            if client:supports_method(method.textDocument_definition) then
                map("n", "gd", FzfLua.lsp_definitions, {
                    silent = true,
                    buffer = ev.buf,
                    desc = "lsp definitions",
                })
            end
            if client:supports_method(method.textDocument_implementation) then
                map("n", "gri", FzfLua.lsp_implementations, {
                    silent = true,
                    buffer = ev.buf,
                    desc = "lsp implementations",
                })
            end
            if client:supports_method(method.textDocument_typeDefinition) then
                map("n", "grt", FzfLua.lsp_typedefs, {
                    silent = true,
                    buffer = ev.buf,
                    desc = "lsp type definitions",
                })
            end
            if client:supports_method(method.textDocument_references) then
                map(
                    "n",
                    "grr",
                    FzfLua.lsp_references,
                    { silent = true, buffer = ev.buf, desc = "lsp references" }
                )
            end
            if client:supports_method(method.textDocument_documentSymbol) then
                map("n", "gO", FzfLua.lsp_document_symbols, {
                    silent = true,
                    buffer = ev.buf,
                    desc = "lsp document symbols",
                })
            end

            map("n", "ga", FzfLua.diagnostics_document, {
                silent = true,
                buffer = ev.buf,
                desc = "diagnostics document",
            })
            map("n", "gw", FzfLua.diagnostics_workspace, {
                silent = true,
                buffer = ev.buf,
                desc = "diagnostics workspace",
            })
        end,
    })

    local servers =
        vim.list_extend(require("mason-lspconfig").get_installed_servers(), {
            "beancount-lsp-server",
            -- "tsgo"
        })

    for _, server in ipairs(servers) do
        local opts
        if server == "jsonls" then
            opts = {
                settings = {
                    json = {
                        schemas = require("schemastore").json.schemas(),
                        validate = { enable = true },
                    },
                },
            }
        elseif server == "yamlls" then
            opts = {
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
            }
        elseif server == "harper_ls" then
            opts = {
                filetypes = { "markdown", "text" },
            }
        else
            opts = {}
        end
        opts.capabilities =
            require("blink.cmp").get_lsp_capabilities(opts.capabilities)

        vim.lsp.config(server, opts)
    end

    vim.lsp.enable(servers)
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
            "saghen/blink.cmp",
            "ibhagwan/fzf-lua",
        },
    },
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = { "mason-org/mason.nvim" },
        ---@type MasonLspconfigSettings
        config = {
            automatic_enable = false,
            ensure_installed = {
                "jsonls",
                "cssls",
                "html",
                "eslint",
                "lua_ls",
                "ts_ls",
                "yamlls",
            },
        },
    },
}
