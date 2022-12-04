(import-macros {: xmap! : nmap! : map! : req!} :enoch.macros)

(fn on-attach [client bufnr]
  (vim.api.nvim_buf_set_option bufnr :omnifunc "v:lua.vim.lsp.omnifunc")
  (nmap! :K vim.lsp.buf.hover)
  (nmap! :gd (req! :telescope.builtin :lsp_definitions))
  (nmap! :gi (req! :telescope.builtin :lsp_implementations))
  (nmap! :gy (req! :telescope.builtin :lsp_type_definitions))
  (nmap! :gr (req! :telescope.builtin :lsp_references))
  (nmap! :gs (req! :telescope.builtin :lsp_document_symbols))
  (map! [:x :n] :<leader>f #((req! :enoch.format :format) client.name))
  (nmap! "[g" vim.diagnostic.goto_prev)
  (nmap! "g]" vim.diagnostic.goto_next)
  (nmap! :ga #((req! :telescope.builtin :diagnostics) {:bufnr 0}))
  (nmap! :gw (req! :telescope.builtin :diagnostics))
  (nmap! :<leader>a vim.lsp.buf.code_action)
  (xmap! :<leader>a ":<C-U>lua vim.lsp.buf.range_code_action()<CR>")
  (nmap! :<leader>rn vim.lsp.buf.rename))

{: on-attach}
