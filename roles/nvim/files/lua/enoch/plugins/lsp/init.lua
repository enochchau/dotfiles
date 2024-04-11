local function config()
    local lspconfig = require "lspconfig"
    local mason = require "mason"
    local lsp_opts = require "enoch.plugins.lsp.lsp-opts"
    local additional_lspconfig = require "enoch.plugins.lsp.configs"

    local function enable_icon_signs()
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
    end

    mason.setup()
    enable_icon_signs()
    vim.diagnostic.config { virtual_text = false }

    local servers = {
        ["ansiblels"] = true,
        ["astro"] = true,
        ["bashls"] = true,
        ["cssls"] = true,
        ["eslint"] = true,
        ["fennel-language-server"] = false,
        -- ["fennel-ls"] = false,
        ["prismals"] = true,
        ["pyright"] = true,
        ["gopls"] = true,
        ["html"] = true,
        ["jsonls"] = true,
        ["rust_analyzer"] = true,
        ["lua_ls"] = true,
        ["terraformls"] = true,
        ["tsserver"] = true,
        ["yamlls"] = true,
        ["zls"] = true,
        ["ocamllsp"] = true,
    }

    -- setup
    for _, server in ipairs(vim.tbl_keys(servers)) do
        -- setup additional lsp server configs
        if additional_lspconfig[server] then
            additional_lspconfig[server]()
        end

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
        "williamboman/mason.nvim",
        "b0o/schemastore.nvim",
        "onsails/lspkind.nvim",
        "ibhagwan/fzf-lua",
    },
    config = config,
}
