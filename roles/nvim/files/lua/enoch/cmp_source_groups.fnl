(macro source-group! [...]
  (let [t []]
    (each [_ value (ipairs [...])]
      (table.insert t {:name value}))
    t))

{:lsp (source-group! :nvim_lsp :luasnip)
 :buffer (source-group! :buffer)
 :path (source-group! :path)
 :spell (source-group! :spell)
 :path (source-group! :path)
 :cmdline (source-group! :cmdline)}
