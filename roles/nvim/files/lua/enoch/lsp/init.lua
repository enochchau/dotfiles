local lspconfig = require "lspconfig"
local mason = require "mason"
local lsp_opts = require "enoch.lsp.lsp-opts"
local null_ls = require "null-ls"
local mason_null_ls = require "mason-null-ls"

-- setup additional lsp configs before loading lspconfig
require "enoch.lsp.configs"

local has_termux = vim.env.TERMUX ~= nil

local function enable_icon_signs()
    local signs =
        { Error = " ", Warn = " ", Hint = " ", Info = " " }

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
    ["crystalline"] = true,
    ["eslint"] = true,
    ["fennel-language-server"] = false,
    -- ["fennel-ls"] = false,
    ["prismals"] = true,
    ["pyright"] = true,
    ["gopls"] = true,
    ["html"] = true,
    ["jsonls"] = true,
    ["rust_analyzer"] = true,
    ["sumneko_lua"] = true,
    ["terraformls"] = true,
    ["tsserver"] = true,
    ["vimls"] = true,
    ["yamlls"] = true,
    ["zls"] = true,
}

if not has_termux then
    require("mason-lspconfig").setup {
        ensure_installed = vim.tbl_filter(function(val)
            return servers[val]
        end, vim.tbl_keys(servers)),
    }
end

-- setup
for _, server in ipairs(vim.tbl_keys(servers)) do
    local config
    if lsp_opts[server] then
        config = lsp_opts[server]()
    else
        config = lsp_opts.create_default_opts()
    end

    lspconfig[server].setup(config)
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
null_ls.setup {
    on_attach = lsp_opts.common_on_attach,
    sources = {
        formatting.prettierd.with {
            env = {
                ["PRETTIERD_DEFAULT_CONFIG"] = vim.fn.expand "~/.config/nvim/.prettierrc",
            },
            extra_filetypes = { "astro", "html" },
        },
        formatting.stylua,
        formatting.fnlfmt,
        diagnostics.shellcheck,
        formatting.black,
        diagnostics.mypy,
    },
}

if not has_termux then
    mason_null_ls.setup { automatic_installation = true }
end
