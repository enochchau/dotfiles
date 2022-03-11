command! FmtNls :lua vim.lsp.buf.formatting_seq_sync({}, 3000, { 'null-ls' })<CR>

augroup FmtJavaScript
  autocmd!
  " use prettier then eslint
  autocmd BufWritePre *.js,*.ts,*.jsx,*.tsx lua vim.lsp.buf.formatting_seq_sync({}, 3000, { 'null-ls', 'eslint' })
augroup END

augroup FmtMarkdown
  autocmd!
  autocmd BufWritePre *.md lua vim.lsp.buf.formatting_seq_sync({}, 3000, { 'null-ls' })
augroup END
