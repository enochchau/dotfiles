command! FmtNls :lua vim.lsp.buf.formatting_seq_sync({}, 3000, { 'null-ls' })<CR>

function! SpecificJSFormat()
  let s:path = expand('%:p')
  if s:path =~ 'Gatsby/repo'
    " use only eslint at work
    lua vim.lsp.buf.formatting_seq_sync({}, 3000, { 'eslint' })
  else
    " use both prettier and eslint
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
  autocmd BufWritePre *.md lua vim.lsp.buf.formatting_seq_sync({}, 3000, { 'null-ls' })
augroup END
