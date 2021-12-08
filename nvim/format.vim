lua << EOF
  local prettier = "prettier -w"

  require("format").setup {
    javascript = { 
      { cmd = { prettier } } 
    },
    javascriptreact = { 
      { cmd = { prettier } } 
    },
    markdown = { 
      { cmd = { prettier } } 
    },
    typescript = { 
      { cmd = { prettier } } 
    },
    typescriptreact = { 
      { cmd = { prettier } } 
    },
    css = {
      { cmd = {prettier} }
    },
    scss = {
      { cmd = {prettier} }
    }
  }
EOF
command! -nargs=0 Prettier FormatWrite!
" format on save with Prettier
autocmd BufWritePre *.md,*.css,*.scss Prettier
" format on save with eslint
autocmd BufWritePre *.js,*.jsx,*.ts,*.tsx lua vim.lsp.buf.formatting_seq_sync(nil, nil, { 'eslint' })
