command! FmtNls :lua vim.lsp.buf.formatting_seq_sync({}, 5000, { 'null-ls' })<CR>
