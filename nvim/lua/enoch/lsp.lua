local lsp_installer = require "nvim-lsp-installer"
local lspsaga = require('lspsaga')
local cmp_nvim_lsp = require('cmp_nvim_lsp')

lspsaga.setup()

-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

local function common_on_attach(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  local telescope_picker = function(picker) return '<cmd>lua require"telescope.builtin".' .. picker .. '()<CR>' end
  local lspsaga_func = function(action) return '<cmd>Lspsaga ' .. action .. '<CR>' end

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = {
    noremap = true,
    silent = true
  }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gd', telescope_picker('lsp_definitions'), opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', telescope_picker('lsp_implementations'), opts)
  buf_set_keymap('n', 'gy', telescope_picker('lsp_type_definitions'), opts)
  buf_set_keymap('n', 'gr', telescope_picker('lsp_references'), opts)
  buf_set_keymap('n', '[g', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']g', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('x', '<leader>f', ':<C-U>lua vim.lsp.buf.range_formatting()<CR>', opts)
  buf_set_keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  buf_set_keymap('n', 'ga', telescope_picker('lsp_document_diagnostics'), opts)
  buf_set_keymap('x', '<leader>a', ':<C-U>Lspsaga range_code_action<CR>', opts)
  buf_set_keymap('n', '<leader>a', lspsaga_func('code_action'), opts)
  buf_set_keymap('n', '<leader>rn', lspsaga_func('rename'), opts)
end

lsp_installer.on_server_ready(function(server)
  local opts = {
    on_attach = common_on_attach,
    capabilities = capabilities
  }

  if server.name == "eslint" then
    -- tell lsp that eslint can be used as a formatter
    opts.on_attach = function(client, bufnr)
      client.resolved_capabilities.document_formatting = true
      common_on_attach(client, bufnr)
    end

    -- for yarn pnp
    local default_opts = server:get_default_options()
    opts.cmd = vim.list_extend({
      "yarn",
      "node"
    }, default_opts.cmd)

    opts.settings = {
      format = {
        enable = true
      } -- this will enable formatting
    }
  end

  if server.name == 'tsserver' then
    opts.init_options = require("nvim-lsp-ts-utils").init_options

    opts.on_attach = function(client, bufnr)
      local ts_utils = require("nvim-lsp-ts-utils")
      ts_utils.setup{}
      ts_utils.setup_client(client)
      local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
      local keymap_opts = { silent = true, noremap = true }
      buf_set_keymap('n', '<leader>o', ":TSLspOrganize<CR>", keymap_opts)
      buf_set_keymap('n', '<leader>rf', ":TSLspRenameFile<CR>", keymap_opts)
      buf_set_keymap('n', '<leader>i', ":TSLspImportAll<CR>", keymap_opts)

      common_on_attach(client, bufnr)
    end
  end

  server:setup(opts)
end)

-- show diagnostic on hover instead of in virtual text
vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]
vim.diagnostic.config {
  virtual_text = false
}
