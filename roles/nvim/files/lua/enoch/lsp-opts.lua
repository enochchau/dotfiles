local pnp_checker = require("nvim-pnp-checker")
local telescope_builtin = require("telescope.builtin")
local lsp_ts_utils = require("nvim-lsp-ts-utils")
local nnoremap = require("enoch.helpers").nnoremap
local xnoremap = require("enoch.helpers").xnoremap
local cmp_nvim_lsp = require("cmp_nvim_lsp")

---append to schema store url
---@param file_name string
---@return string
local function schema_store(file_name)
  return "https://json.schemastore.org/" .. file_name
end

local function common_on_attach(client, bufnr)
  vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

  nnoremap("gd", telescope_builtin.lsp_definitions)
  nnoremap("K", vim.lsp.buf.hover)
  nnoremap("gi", telescope_builtin.lsp_implementations)
  nnoremap("gy", telescope_builtin.lsp_type_definitions)
  nnoremap("gr", telescope_builtin.lsp_references)
  nnoremap("gs", telescope_builtin.lsp_document_symbols)

  xnoremap("<leader>f", ":<C-U>lua vim.lsp.buf.range_formatting()<CR>")
  nnoremap("<leader>f", vim.lsp.buf.formatting)

  nnoremap("[g", vim.diagnostic.goto_prev)
  nnoremap("g]", vim.diagnostic.goto_next)
  nnoremap("ga", function()
    telescope_builtin.diagnostics({ bufnr = 0 })
  end)
  nnoremap("gw", telescope_builtin.diagnostics)

  nnoremap("<leader>a", vim.lsp.buf.code_action)
  xnoremap("<leader>a", ":<C-U>lua vim.lsp.buf.range_code_action()<CR>")
  nnoremap("<leader>rn", vim.lsp.buf.rename)
end

---create cmp-nvim-lsp client capabilities
---@return any
local function create_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  return cmp_nvim_lsp.update_capabilities(capabilities)
end

---create default lsp client opts
---@return table
local function create_default_opts()
  return {
    on_attach = common_on_attach,
    capabilities = create_capabilities(),
  }
end

---add snippet support
---@param capabilities table
---@return table
local function add_snippet_support(capabilities)
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  return capabilities
end

local function sumneko_lua()
  local function get_runtime_path()
    local runtime_path = vim.split(package.path, ";")
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")
    return runtime_path
  end

  local root = vim.fn.getcwd()
  local opts = create_default_opts()

  if string.match(root, "nvim") then
    opts.settings = {
      Lua = {
        runtime = { version = "LuaJIT", path = get_runtime_path() },
        diagnostics = { globals = { "vim" } },
        workspace = { library = vim.api.nvim_get_runtime_file("", true) },
        telemetry = { enable = false },
      },
    }
  elseif string.match(root, "hammerspoon") then
    opts.settings = {
      Lua = {
        diagnostics = { globals = { "hs" } },
        workspace = {
          library = {
            "/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/",
          },
        },
        telemetry = { enable = false },
      },
    }
  else
    opts.settings = {
      Lua = {
        telemetry = { enable = false },
      },
    }
  end

  return opts
end

local function eslint()
  local opts = create_default_opts()

  opts.on_attach = function(client, bufnr)
    client.resolved_capabilities.document_formatting = true
    common_on_attach(client, bufnr)
  end

  if pnp_checker.check_for_pnp() then
    opts.cmd = pnp_checker.get_pnp_cmd()
  end

  return opts
end

local function html()
  local opts = create_default_opts()
  opts.capabilities = add_snippet_support(opts.capabilities)
  return opts
end

local function cssls()
  local opts = create_default_opts()
  opts.capabilities = add_snippet_support(opts.capabilities)
  return opts
end

local function jsonls()
  ---@param file_match table
  ---@param file_url_name string
  local function get_schema(file_match, file_url_name)
    return { fileMatch = file_match, url = schema_store(file_url_name) }
  end

  local opts = create_default_opts()
  opts.capabilities = add_snippet_support(opts.capabilities)
  opts.on_attach = function(client, bufnr)
    -- use prettier for formatting
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false
    common_on_attach(client, bufnr)
  end
  opts.settings = {
    json = {
      schemas = {
        get_schema({ "package.json" }, "package.json"),
        get_schema({ "tsconfig*.json" }, "tsconfig.json"),
        get_schema(
          { ".prettierrc", ".prettierrc.json", "prettier.config.json" },
          "prettierrc.json"
        ),
        get_schema({ ".eslintrc.", ".eslintrc.json" }, "eslintrc.json"),
        get_schema(
          { ".babelrc", ".babelrc.json", "babel.config.json" },
          "babelrc.json"
        ),
        get_schema({ "lerna.json" }, "lerna.json"),
      },
    },
  }
  return opts
end

local function yammls()
  local opts = create_default_opts()
  opts.on_attach = function(client, bufnr)
    client.resolved_capabilities.document_formatting = false
    common_on_attach(client, bufnr)
  end
  opts.settings = {
    schemas = {
      ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = "docker-compose*.{yml,yaml}",
      [schema_store("github-workflow.json")] = ".github/workflows/*.{yml,yaml}",
      [schema_store("github-action.json")] = ".github/action.{yml,yaml}",
      [schema_store("prettierrc.json")] = ".prettierrc.{yml,yaml}",
    },
  }
  return opts
end

local function tsserver()
  local opts = create_default_opts()
  opts.on_attach = function(client, bufnr)
    lsp_ts_utils.setup({ auto_inlay_hints = false })
    lsp_ts_utils.setup_client(client)

    nnoremap("<leader>o", ":TSLspOrganize<CR>")
    nnoremap("<leader>rf", ":TSLspRenameFile<CR>")
    nnoremap("<leader>i", ":TSLspImportAll<CR>")

    -- use prettierd and eslint for formatting
    client.resolved_capabilities.document_formatting = false
    client.resolved_capabilities.document_range_formatting = false
    common_on_attach(client, bufnr)
  end
  opts.init_options = lsp_ts_utils.init_options
  return opts
end

return {
  common_on_attach = common_on_attach,
  create_default_opts = create_default_opts,
  sumneko_lua = sumneko_lua,
  eslint = eslint,
  html = html,
  cssls = cssls,
  jsonls = jsonls,
  yammls = yammls,
  tsserver = tsserver,
}
