local cmp_nvim_lsp = require("cmp_nvim_lsp")
local lsp_installer = require("nvim-lsp-installer")
local null_ls = require("null-ls")

---binds keymap for a given buffer
---@param bufnr any the current buffer
---@param keymap table a 2D table with rows: { mode, keys, command }
local function bind_keymap(bufnr, keymap)
  local opts = { silent = true, noremap = true, buffer = bufnr }

  for _, mapping in pairs(keymap) do
    table.insert(mapping, opts)
    vim.keymap.set(unpack(mapping))
  end
end

local function common_on_attach(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  ---@param picker string name of the builtin telescope picker
  local telescope_picker = function(picker)
    return '<cmd>lua require"telescope.builtin".' .. picker .. "()<CR>"
  end

  local keymap = {
    { "n", "gd", telescope_picker("lsp_definitions") },
    { "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>" },
    { "n", "gi", telescope_picker("lsp_implementations") },
    { "n", "gy", telescope_picker("lsp_type_definitions") },
    { "n", "gr", telescope_picker("lsp_references") },
    { "n", "gs", telescope_picker("lsp_document_symbols") },
    { "n", "[g", "<cmd>lua vim.diagnostic.goto_prev()<CR>" },
    { "n", "]g", "<cmd>lua vim.diagnostic.goto_next()<CR>" },
    { "x", "<leader>f", ":<C-U>lua vim.lsp.buf.range_formatting()<CR>" },
    { "n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>" },
    { "n", "ga", "<cmd>Telescope diagnostics bufnr=0<CR>" },
    { "n", "gc", "<cmd>Telescope diagnostics<CR>" },
    { "n", "<leader>a", telescope_picker("lsp_code_actions") },
    { "x", "<leader>a", ":Telescope lsp_range_code_actions<CR>" },
    { "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>" },
  }

  bind_keymap(bufnr, keymap)
end

-- use custom icons
local signs = {
  Error = " ",
  Warn = " ",
  Hint = " ",
  Info = " ",
}

for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, {
    text = icon,
    texthl = hl,
    numhl = hl,
  })
end

vim.diagnostic.config({
  virtual_text = false,
})

vim.api.nvim_set_keymap(
  "n",
  "<leader>d",
  "<cmd>lua vim.diagnostic.open_float(nil, {focus=false})<CR>",
  { noremap = true, silent = true }
)

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

-- auto install servers
for _, name in pairs(servers) do
  local server_is_found, server = lsp_installer.get_server(name)
  if server_is_found and not server:is_installed() then
    print("Installing " .. name)
    server:install()
  end
end

local server_init = {
  sumneko_lua = function(opts)
    local runtime_path = vim.split(package.path, ";")
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")

    local root = vim.fn.getcwd()

    if string.match(root, "nvim") then
      -- settings for nvim plugin linting
      opts.settings = {
        Lua = {
          runtime = {
            -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
            version = "LuaJIT",
            -- Setup your lua path
            path = runtime_path,
          },
          diagnostics = {
            -- Get the language server to recognize the `vim` global
            globals = { "vim" },
          },
          workspace = {
            -- Make the server aware of Neovim runtime files
            library = vim.api.nvim_get_runtime_file("", true),
          },
          -- Do not send telemetry data containing a randomized but unique identifier
          telemetry = { enable = false },
        },
      }
    elseif string.match(root, "hammerspoon") then
      opts.settings = {
        Lua = {
          diagnostics = {
            globals = { "hs" },
          },
          workspace = {
            library = {
              ["/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/"] = true,
            },
          },
          telemetry = { enable = false },
        },
      }
    end

    return opts
  end,
  eslint = function(opts)
    -- check for yarn pnp
    local pnp_checker = require("nvim-pnp-checker")
    if pnp_checker.check_for_pnp() then
      opts.cmd = pnp_checker.get_pnp_cmd()
    end

    opts.on_attach = function(client, bufnr)
      client.resolved_capabilities.document_formatting = true
      common_on_attach(client, bufnr)
    end
    return opts
  end,
  html = function(opts)
    opts.capabilities.textDocument.completion.completionItem.snippetSupport =
      true
    return opts
  end,
  cssls = function(opts)
    opts.capabilities.textDocument.completion.completionItem.snippetSupport =
      true
    return opts
  end,
  jsonls = function(opts)
    opts.capabilities.textDocument.completion.completionItem.snippetSupport =
      true
    -- https://www.reddit.com/r/neovim/comments/n1n4zc/need_help_with_tsconfigjson_autocompletion_with/
    opts.settings = {
      json = {
        schemas = {
          {
            fileMatch = { "package.json" },
            url = "https://json.schemastore.org/package.json",
          },
          {
            fileMatch = { "tsconfig*.json" },
            url = "https://json.schemastore.org/tsconfig.json",
          },
          {
            fileMatch = {
              ".prettierrc",
              ".prettierrc.json",
              "prettier.config.json",
            },
            url = "https://json.schemastore.org/prettierrc.json",
          },
          {
            fileMatch = { ".eslintrc", ".eslintrc.json" },
            url = "https://json.schemastore.org/eslintrc.json",
          },
          {
            fileMatch = { ".babelrc", ".babelrc.json", "babel.config.json" },
            url = "https://json.schemastore.org/babelrc.json",
          },
          {
            fileMatch = { "lerna.json" },
            url = "https://json.schemastore.org/lerna.json",
          },
        },
      },
    }
    opts.on_attach = function(client, bufnr)
      -- use null-ls for formatting instead
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false
      common_on_attach(client, bufnr)
    end
    return opts
  end,
  yamlls = function(opts)
    opts.on_attach = function(client, bufnr)
      -- use prettier/null-ls for formatting
      client.resolved_capabilities.document_formatting = false
      common_on_attach(client, bufnr)
    end
    opts.settings = {
      schemas = {
        ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = {
          "docker-compose*.{yml,yaml}",
        },
        ["http://json.schemastore.org/github-workflow.json"] = ".github/workflows/*.{yml,yaml}",
        ["http://json.schemastore.org/github-action.json"] = ".github/action.{yml,yaml}",
        ["http://json.schemastore.org/prettierrc.json"] = ".prettierrc.{yml,yaml}",
      },
    }
    return opts
  end,
  tsserver = function(opts)
    opts.init_options = require("nvim-lsp-ts-utils").init_options

    opts.on_attach = function(client, bufnr)
      local ts_utils = require("nvim-lsp-ts-utils")
      ts_utils.setup({
        auto_inlay_hints = false,
      })
      ts_utils.setup_client(client)

      local keymap = {
        { "n", "<leader>o", ":TSLspOrganize<CR>" },
        { "n", "<leader>rf", ":TSLspRenameFile<CR>" },
        { "n", "<leader>i", ":TSLspImportAll<CR>" },
      }

      bind_keymap(bufnr, keymap)

      -- use null-ls for formatting instead of tsserver
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false

      common_on_attach(client, bufnr)
    end
    return opts
  end,
}

-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

-- attach servers
lsp_installer.on_server_ready(function(server)
  local opts = {
    on_attach = common_on_attach,
    capabilities = capabilities,
  }

  if server_init[server.name] then
    opts = server_init[server.name](opts)
  end

  server:setup(opts)
end)

-- register null-ls
-- register any number of sources simultaneously
local sources = {
  null_ls.builtins.formatting.prettierd.with({
    env = {
      PRETTIERD_DEFAULT_CONFIG = vim.fn.expand("~/.config/nvim/.prettierrc"),
    },
  }),
  null_ls.builtins.formatting.stylua,
  null_ls.builtins.formatting.fnlfmt,
}

null_ls.setup({
  sources = sources,
  on_attach = common_on_attach,
})
