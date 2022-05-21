local lspconfig = require("lspconfig")
local lsp_opts = require("enoch.lsp-opts")
local lsp_installer = require("nvim-lsp-installer")
local nnoremap = require("enoch.helpers").nnoremap
local null_ls = require("null-ls")

local function enable_icon_signs()
  local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }

  for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
  end
end

local function remap_diagnostic()
  vim.diagnostic.config({ virtual_text = false })
  nnoremap("<leader>d", function()
    vim.diagnostic.open_float(nil, { focus = false })
  end)
end

---@param name string name of langauge server
local function install_language_server(name)
  local server_is_found, server = lsp_installer.get_server(name)
  if server_is_found and not server:is_installed() then
    print("Installing " .. name)
    server:install()
  end
end

lsp_installer.setup({})
enable_icon_signs()
remap_diagnostic()
local servers = {
  "ansiblels",
  "bashls",
  "cssls",
  "eslint",
  "gopls",
  "html",
  "jsonls",
  "sumneko_lua",
  "terraformls",
  "tsserver",
  "vimls",
  "yamlls",
  "zls",
}
-- install
for _, server in ipairs(servers) do
  install_language_server(server)
end
-- setup
for _, server in ipairs(servers) do
  if lsp_opts[server] then
    lspconfig[server].setup(lsp_opts[server]())
  else
    lspconfig[server].setup(lsp_opts.create_default_opts())
  end
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
null_ls.setup({
  on_attach = lsp_opts.common_on_attach,
  sources = {
    formatting.prettierd.with({
      env = {
        ["PRETTIERD_DEFAULT_CONFIG"] = vim.fn.expand(
          "~/.config/nvim/.prettierrc"
        ),
      },
    }),
    formatting.stylua,
    formatting.fnlfmt,
    diagnostics.shellcheck,
  },
})
