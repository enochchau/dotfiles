lua << EOF
  local prettier = function()
    return {
      exe = 'prettierd',
      args = {vim.api.nvim_buf_get_name(0)},
      stdin = true
    }
  end

  require("formatter").setup{
    logging = true,
    filetype = {
      typescriptreact = { prettier },
      typescript = { prettier },
      javascriptreact = { prettier },
      javascript = { prettier },
      markdown = { prettier },
      css = { prettier },
      scss = { prettier },
      yaml = { prettier },
      graphql = { prettier }
    }
  }
EOF

command! -nargs=0 Prettier Format
command! -nargs=0 TSFmt lua vim.lsp.buf.formatting_seq_sync(nil, nil, { 'tsserver' })
command! -nargs=0 EslintFix lua vim.lsp.buf.formatting_seq_sync(nil, nil, { 'eslint' })
