(local luasnip (require :luasnip))
(local cmp (require :cmp))

(fn has_words_before []
  (let [[line col] (vim.api.nvim_win_get_cursor 0)
        word (. (vim.api.nvim_buf_get_lines 0 (- line 1) line true) 1)]
    (and (not= col 0) (= (-> word
                             (strings.sub col col)
                             (strings.match "%s")) nil))))

(fn expand-snippet [args]
  (luasnip.lsp_expand args.body))

(fn tab-mapping [fallback]
  (if (cmp.visible) (cmp.select_next_item)
      (luasnip.expand_or_jumpable) (luasnip.expand_or_jump)
      (has_words_before) (cmp.complete)
      (fallback))
  nil)

(fn stab-mapping [fallback]
  (if (cmp.visible) (cmp.select_prev_item)
      (luasnip.jumpable -1) (luasnip.jump -1)
      (fallback))
  nil)

(fn source_group [...]
  (let [t []]
    (each [i v (ipairs [...])]
      (table.insert t {:name v}))
    t))

(fn setup-cmdline []
  "setup cmp command line"
  (cmp.setup.cmdline "/" {:sources (source_group :buffer)})
  (cmp.setup.cmdline ":"
                     {:sources (cmp.config.sources (source_group :path)
                                                   (source_group :cmdline))}))

(fn setup []
  "setup cmp"
  (cmp.setup {:snippet {:expand expand-snippet}
              :mapping {:<Tab> (cmp.mapping tab-mapping [:i :s])
                        :<S-Tab> (cmp.mapping stab-mapping [:i :s])
                        :<CR> (cmp.mapping.confirm {:select true})}
              :sources (cmp.config.sources (source_group :nvim_lsp :luasnip)
                                           (source_group :buffer)
                                           (source_group :path)
                                           (source_group :treesitter)
                                           (source_group :spell))}))

(setup)
(setup-cmdline)
