local function config()
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
            local client = vim.lsp.get_client_by_id(ev.data.client_id)
            if client == nil then
                return
            end

            local map = vim.keymap.set
            local map_opts = { noremap = true, silent = true, buffer = ev.buf }
            local method = vim.lsp.protocol.Methods

            vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

            if client:supports_method(method.textDocument_rename) then
                map("n", "<leader>rn", vim.lsp.buf.rename, map_opts)
            end
            if client:supports_method(method.textDocument_definition) then
                map("n", "gd", ":Pick lsp scope='definition'<CR>", map_opts)
            end
            if client:supports_method(method.textDocument_implementation) then
                map("n", "gi", ":Pick lsp scope='implementation'<CR>", map_opts)
            end
            if client:supports_method(method.textDocument_typeDefinition) then
                map(
                    "n",
                    "gy",
                    ":Pick lsp scope='type_definition'<CR>",
                    map_opts
                )
            end
            if client:supports_method(method.textDocument_references) then
                map("n", "gr", ":Pick lsp scope='references'<CR>", map_opts)
            end
            if client:supports_method(method.textDocument_documentSymbol) then
                map(
                    "n",
                    "gs",
                    ":Pick lsp scope='document_symbol'<CR>",
                    map_opts
                )
            end

            map("n", "ga", ":Pick diagnostic scope='current'<CR>", map_opts)
            map("n", "gw", ":Pick diagnostic scope='all'<CR>", map_opts)

            if client:supports_method(method.textDocument_codeAction) then
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
            "b0o/schemastore.nvim",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "saghen/blink.cmp",
            "nvim-mini/mini.extra",
        },
    },
    {
        "williamboman/mason-lspconfig.nvim",
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
