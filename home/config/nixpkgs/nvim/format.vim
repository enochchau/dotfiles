function! SpecificJSFormat()
  let s:path = expand('%:p')
  if s:path =~ 'Gatsby/repo'
    " use only eslint at work
    echo "Formatting with Eslint"
    lua require('nvim-format-select').formatting_sync_select('eslint', {}, 3000)
  else
    " use both prettier and eslint
    echo "Formatting with Prettier and Eslint"
    lua vim.lsp.buf.formatting_seq_sync({}, 3000, { 'null-ls', 'eslint' })
  endif
endfunction

augroup FmtJavaScript
  autocmd!
  " use prettier then eslint
  autocmd BufWritePre *.js,*.ts,*.jsx,*.tsx call SpecificJSFormat()
augroup END

augroup FmtMarkdown
  autocmd!
  autocmd BufWritePre *.md lua vim.lsp.buf.formatting_sync()
augroup END
