(fn nnoremap [lhs rhs]
  (vim.keymap.set :n lhs rhs {:noremap true :silent true}))

{: nnoremap}
