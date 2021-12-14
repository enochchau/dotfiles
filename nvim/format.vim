lua << EOF
  local prettier = function()
    return {
      exe = 'PRETTIERD_DEFAULT_CONFIG=$HOME/.config/nvim/.prettierrc prettierd',
      args = {vim.api.nvim_buf_get_name(0)},
      stdin = true
    }
  end

  local lua_format = function()
    return {
      exe = 'lua-format',
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
      vue = { prettier },
      html = { prettier },
      svelte = { prettier },
      graphql = { prettier },
      lua = { lua_format }
    }
  }
EOF

command! -nargs=0 Prettier Format
command! -nargs=0 TSFmt lua vim.lsp.buf.formatting_seq_sync(nil, nil, { 'tsserver' })

" restart prettierd if default config is changed
augroup prettierd_restart
  autocmd!
  autocmd BufWritePre ~/.config/nvim/.prettierrc !kill `pgrep prettierd`
augroup END

" auto format markdown files
augroup md_fmt
  autocmd!
  autocmd BufWritePost *.md FormatWrite
augroup END
