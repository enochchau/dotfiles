(fn nnoremap [lhs rhs buffer]
  (vim.keymap.set :n lhs rhs {:noremap true :silent true : buffer}))

(fn xnoremap [lhs rhs buffer]
  (vim.keymap.set :x lhs rhs {:noremap true :silent true : buffer}))

{: nnoremap : xnoremap : augroup}
