local cmp_nvim_lsp = require("cmp_nvim_lsp")
local nvim_lsp = require("lspconfig")

-- @param path string - file path
-- @return boolean
local function file_exists(path)
  local f = io.open(path, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

-- @param bin string - bin to look for
-- @return string - path to bin
local function which(bin)
  local handle = io.popen("which " .. bin)
  return handle:read("*all")
end

-- @return boolean - whether the current workspace has yarn pnp
local function check_for_pnp()
  local lsp_roots = vim.lsp.buf.list_workspace_folders()

  for _, root in ipairs(lsp_roots) do
    -- check if workspace root has a yarnrc.yml
    local yarnrc_path = root .. "/.yarnrc.yml"
    if file_exists(yarnrc_path) then
      for line in io.lines(yarnrc_path) do
        -- see if nodeLinker is specified
        local has_node_linker = string.match(line, "nodeLinker")
        if has_node_linker ~= nil then
          -- found a pnp repo
          return not (
              string.match(line, "node-modules") or string.match(line, "pnpm")
            )
        end
      end
      -- no nodeLinker strategy was found so defauls to pnp
      return true
    end
  end

  return false
end

local function common_on_attach(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  -- @param picker string - name of the builtin telescope picker
  local telescope_picker = function(picker)
    return '<cmd>lua require"telescope.builtin".' .. picker .. "()<CR>"
  end

  -- Mappings.
  local opts = {
    noremap = true,
    silent = true,
  }

  local keymap = {
    { "n", "gd", telescope_picker("lsp_definitions"), opts },
    { "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts },
    { "n", "gi", telescope_picker("lsp_implementations"), opts },
    { "n", "gy", telescope_picker("lsp_type_definitions"), opts },
    { "n", "gr", telescope_picker("lsp_references"), opts },
    { "n", "gs", telescope_picker("lsp_document_symbols"), opts },
    { "n", "[g", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts },
    { "n", "]g", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts },
    {
      "x",
      "<leader>f",
      ":<C-U>lua vim.lsp.buf.range_formatting()<CR>",
      opts,
    },
    { "n", "<leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts },
    { "n", "ga", "<cmd>Telescope diagnostics bufnr=0<CR>", opts },
    { "n", "<leader>a", telescope_picker("lsp_code_actions"), opts },
    { "x", "<leader>a", ":Telescope lsp_range_code_actions<CR>", opts },
    { "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts },
  }

  for i, keys in ipairs(keymap) do
    vim.api.nvim_buf_set_keymap(bufnr, unpack(keys))
  end
end

vim.diagnostic.config({
  virtual_text = false,
})

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

-- show diagnostic on hover instead of in virtual text
vim.cmd(
  [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]
)

-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

local servers = {
  "tsserver",
  "eslint",
  "html",
  "cssls",
  "jsonls",
  "bashls",
  "vimls",
  "rnix",
  "sumneko_lua",
  "yamlls",
}

for _, lsp in ipairs(servers) do
  local opts = {
    on_attach = common_on_attach,
    capabilities = capabilities,
  }

  if lsp == "sumneko_lua" then
    local runtime_path = vim.split(package.path, ";")
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")

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
  end

  if lsp == "eslint" then
    -- for yarn pnp
    if check_for_pnp() then
      local eslint_path = which("vscode-eslint-language-server")
      opts.cmd = { "yarn", "node", eslint_path, "--stdio" }
    end
  end

  if lsp == "html" or lsp == "cssls" then
    opts.capabilities.textDocument.completion.completionItem.snippetSupport =
      true
  end

  if lsp == "jsonls" then
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
  end

  if lsp == "yamlls" then
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
  end

  if lsp == "tsserver" then
    opts.init_options = require("nvim-lsp-ts-utils").init_options

    opts.on_attach = function(client, bufnr)
      local ts_utils = require("nvim-lsp-ts-utils")
      ts_utils.setup({
        auto_inlay_hints = false,
      })
      ts_utils.setup_client(client)
      local function buf_set_keymap(...)
        vim.api.nvim_buf_set_keymap(bufnr, ...)
      end
      local keymap_opts = {
        silent = true,
        noremap = true,
      }
      buf_set_keymap("n", "<leader>o", ":TSLspOrganize<CR>", keymap_opts)
      buf_set_keymap("n", "<leader>rf", ":TSLspRenameFile<CR>", keymap_opts)
      buf_set_keymap("n", "<leader>i", ":TSLspImportAll<CR>", keymap_opts)

      -- use null-ls for formatting instead of tsserver
      client.resolved_capabilities.document_formatting = false
      client.resolved_capabilities.document_range_formatting = false

      common_on_attach(client, bufnr)
    end
  end

  nvim_lsp[lsp].setup(opts)
end
