local function config()
    local lspconfig = require "lspconfig"
    local lsp_opts = require "enoch.plugins.lsp.lsp-opts"

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

    local servers = {
        "ansiblels",
        "astro",
        "bashls",
        "cssls",
        "eslint",
        "pyright",
        "gopls",
        "html",
        "jsonls",
        "rust_analyzer",
        "lua_ls",
        "terraformls",
        "tsserver",
        "yamlls",
    }

    -- setup
    for _, server in ipairs(servers) do
        local config
        if lsp_opts[server] then
            config = lsp_opts[server]()
        else
            config = lsp_opts.create_default_opts()
        end

        lspconfig[server].setup(config)
    end
end

---@type LazySpec
return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "b0o/schemastore.nvim",
        "onsails/lspkind.nvim",
        "ibhagwan/fzf-lua",
        "williamboman/mason.nvim",
    },
    config = config,
}
