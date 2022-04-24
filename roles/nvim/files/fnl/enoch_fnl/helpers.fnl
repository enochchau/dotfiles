(fn nnoremap [lhs rhs buffer]
  (vim.keymap.set :n lhs rhs {:noremap true :silent true : buffer}))

(fn xnoremap [lhs rhs buffer]
  (vim.keymap.set :x lhs rhs {:noremap true :silent true : buffer}))

(fn table-merge [t1 t2]
  (each [k v (pairs t2)]
    (tset t1 k v)))

{: nnoremap : xnoremap : table-merge}
