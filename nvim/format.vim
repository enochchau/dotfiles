lua << EOF
  local prettier = {
    exe = 'prettierd',
    args = {vim.api.nvim_buf_get_name(0)},
    stdin = true
  }

  require("formatter").setup{
    logging = true,
    filetype = {
      typescriptreact = { 
        function()
          return prettier
        end
      },
      typescript = { 
        function()
          return prettier
        end
      },
      javascriptreact = { 
        function()
          return prettier
        end
      },
      javascript = { 
        function()
          return prettier
        end
      },
      markdown = { 
        function()
          return prettier
        end
      },
      css = { 
        function()
          return prettier
        end
      },
      scss = { 
        function()
          return prettier
        end
      },
      yaml = { 
        function()
          return prettier
        end
      },
      graphql = { 
        function()
          return prettier
        end
      }
    }
  }
EOF
command! -nargs=0 Prettier Format
" format on save with Prettier
autocmd BufWritePre *.md,*.css,*.scss Prettier
" format on save with eslint
autocmd BufWritePre *.js,*.jsx,*.ts,*.tsx lua vim.lsp.buf.formatting_seq_sync(nil, nil, { 'eslint' })
