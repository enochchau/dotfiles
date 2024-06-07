local function on_attach(client, bufnr)
    local map = vim.keymap.set
    local map_opts = { noremap = true, silent = true, buffer = bufnr }
    local supports = client.supports_method

    vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

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
end

---create default lsp client opts
---@return table
local function create_default_opts()
    return {
        on_attach = on_attach,
        -- create cmp capabilities
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
    }
end

local lspconfig_opts = {
    jsonls = function()
        local opts = create_default_opts()

        opts.settings = {
            json = {
                schemas = require("schemastore").json.schemas(),
                validate = { enable = true },
            },
        }

        return opts
    end,

    yamlls = function()
        local opts = create_default_opts()

        opts.settings = {
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
        }
        return opts
    end,
}

local function tsserver_opts()
    local opts = create_default_opts()

    -- options for typescript-language-server
    -- opts.init_options = {
    --     maxTsServerMemory = 4096,
    --     npmLocation = "npm",
    -- }
    -- opts.settings = {
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
    -- }

    return opts
end

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

    local servers = vim.tbl_filter(function(server)
        return server ~= "tsserver"
    end, mason_lspconfig.get_installed_servers())
    vim.print(servers)

    -- setup
    require("typescript-tools").setup(tsserver_opts())
    for _, server in ipairs(servers) do
        local opts = lspconfig_opts[server] and lspconfig_opts[server]()
            or create_default_opts()

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
