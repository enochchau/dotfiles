lua << EOF
  local lsp_installer = require "nvim-lsp-installer"
  local lspsaga = require('lspsaga')
  lspsaga.setup()

  function common_on_attach(client, bufnr)
    local telescope = require('telescope')

    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    -- Enable completion triggered by <c-x><c-o>
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap=true, silent=true }

    local telescope = function(picker)
      return '<cmd>lua require"telescope.builtin".' .. picker .. '()<CR>'
    end
    local saga = function(action)
      return '<cmd>Lspsaga ' .. action .. '<CR>'
    end

    -- See `:help vim.lsp.*` for documentation on any of the below functions
    buf_set_keymap('n', 'gd', telescope('lsp_definitions'), opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', telescope('lsp_implementations'), opts)
    buf_set_keymap('n', 'gy', telescope('lsp_type_definitions'), opts)
    buf_set_keymap('n', 'gr', telescope('lsp_references'), opts)
    buf_set_keymap('n', '[g', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']g', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('x', '<leader>f', ':<C-U>lua vim.lsp.buf.range_formatting()<CR>', opts)
    buf_set_keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
    buf_set_keymap('n', 'ga', telescope('lsp_document_diagnostics'), opts)
    buf_set_keymap('x', '<leader>a', ':<C-U>Lspsaga range_code_action<CR>', opts)
    buf_set_keymap('n', '<leader>a', saga('code_action'), opts)
    buf_set_keymap('n', '<leader>rn', saga('rename'), opts)
  end

  lsp_installer.on_server_ready(function (server)
    local opts = {
        on_attach = common_on_attach,
    }

    if server.name == "eslint" then
      opts.on_attach = function (client, bufnr)
        client.resolved_capabilities.document_formatting = true
        common_on_attach(client, bufnr)
      end

      -- for yarn pnp
      local default_opts = server:get_default_options()
      opts.cmd = vim.list_extend({"yarn", "node"}, default_opts.cmd)

      opts.settings = {
        format = { enable = true }, -- this will enable formatting
      }
    end

    server:setup(opts)
  end)
EOF
