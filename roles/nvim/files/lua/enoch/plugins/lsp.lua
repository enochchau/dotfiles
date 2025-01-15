local function config()
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

    vim.diagnostic.config({ virtual_text = false })

    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
            local client = vim.lsp.get_client_by_id(ev.data.client_id)
            local map = vim.keymap.set
            local map_opts = { noremap = true, silent = true, buffer = ev.buf }
            local supports = client.supports_method
            local method = vim.lsp.protocol.Methods

            vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

            local fzf = require("fzf-lua")
            if supports(method.textDocument_rename) then
                map("n", "<leader>rn", vim.lsp.buf.rename, map_opts)
            end
            if supports(method.textDocument_definition) then
                map("n", "gd", fzf.lsp_definitions, map_opts)
            end
            if supports(method.textDocument_implementation) then
                map("n", "gi", fzf.lsp_implementations, map_opts)
            end
            if supports(method.textDocument_typeDefinition) then
                map("n", "gy", fzf.lsp_typedefs, map_opts)
            end
            if supports(method.textDocument_references) then
                map("n", "gr", fzf.lsp_references, map_opts)
            end
            if supports(method.textDocument_documentSymbol) then
                map("n", "gs", fzf.lsp_document_symbols, map_opts)
            end
            if supports(method.textDocument_diagnostic) then
                map("n", "ga", fzf.diagnostics_document, map_opts)
                map("n", "gw", fzf.diagnostics_workspace, map_opts)
            end
            if supports(method.textDocument_codeAction) then
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

    local servers = require("mason-lspconfig").get_installed_servers()
    servers = vim.tbl_filter(function(value)
        return value ~= "ts_ls"
    end, servers)

    require("lspconfig.configs").vtsls = require("vtsls").lspconfig

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
        elseif server == "vtsls" then
            opts = {
                settings = {
                    vtsls = { autoUseWorkspaceTsdk = true },
                },
                root_dir = function(fname)
                    for dir in vim.fs.parents(fname) do
                        if
                            vim.fn.isdirectory(
                                dir .. "/node_modules/typescript"
                            ) == 1
                        then
                            return dir
                        end
                    end

                    local util = require("lspconfig.util")
                    return util.root_pattern("tsconfig.json", "jsconfig.json")(
                        fname
                    ) or util.root_pattern(
                        "package.json",
                        ".git"
                    )(fname)
                end,
            }
        else
            opts = {}
        end
        opts.capabilities =
            require("blink.cmp").get_lsp_capabilities(opts.capabilities)

        require("lspconfig")[server].setup(opts)
    end
end

---@type LazySpec
return {
    {
        "neovim/nvim-lspconfig",
        config = config,
        dependencies = {
            "yioneko/nvim-vtsls",
            "b0o/schemastore.nvim",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "saghen/blink.cmp",
            "ibhagwan/fzf-lua",
        },
    },
    {
        "williamboman/mason-lspconfig.nvim",
        ---@type MasonLspconfigSettings
        config = {
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
