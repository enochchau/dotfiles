local lspconfig = require "lspconfig"
local mason = require "mason"
local lsp_opts = require "enoch.lsp-opts"
local nmap = require("enoch.helpers").nmap
local null_ls = require "null-ls"

local function enable_icon_signs()
    local signs =
        { Error = " ", Warn = " ", Hint = " ", Info = " " }

    for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end
end

local function remap_diagnostic()
    vim.diagnostic.config { virtual_text = false }
    nmap("<leader>d", function()
        vim.diagnostic.open_float(nil, { focus = false })
    end)
end

mason.setup()
enable_icon_signs()
remap_diagnostic()
local servers = {
    "ansiblels",
    "astro",
    "bashls",
    "cssls",
    "crystalline",
    "eslint",
    "prismals",
    "gopls",
    "html",
    "jsonls",
    "rust_analyzer",
    "sumneko_lua",
    "terraformls",
    "tsserver",
    "vimls",
    "yamlls",
    "zls",
}

-- setup
for _, server in ipairs(servers) do
    if lsp_opts[server] then
        lspconfig[server].setup(lsp_opts[server]())
    else
        lspconfig[server].setup(lsp_opts.create_default_opts())
    end
end

require("mason-lspconfig").setup {
    ensure_installed = table.insert(servers, "html-lsp"),
}

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
    },
}
