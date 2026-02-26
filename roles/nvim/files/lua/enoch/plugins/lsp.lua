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

    local esnure_installed = {
        "lua_ls",
        -- "emmylua_ls",
        -- python
        "ruff",
        "ty",
        -- english
        "harper_ls",
        -- webdev
        "cssls",
        "eslint",
        "html",
        "tsgo", -- "ts_ls",
        "tailwindcss",
        -- data ops
        "yamlls",
        "jsonls",
    }

    require("mason-lspconfig").setup({
        ensure_installed = esnure_installed,
        automatic_enable = false,
    })

    -- custom
    local servers = vim.list_extend(vim.deepcopy(esnure_installed), {
        "beancount-lsp-server",
    })

    for _, server in ipairs(servers) do
        local opts = {}
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
            "b0o/schemastore.nvim", -- for jsonls and yamlls in after/lsp/<SERVER>.lua
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "saghen/blink.cmp",
            "ibhagwan/fzf-lua",
        },
    },
}
