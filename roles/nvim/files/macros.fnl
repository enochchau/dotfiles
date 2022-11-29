(fn nmap! [lhs rhs buffer]
  `(vim.keymap.set :n ,lhs ,rhs {:noremap true :silent true :buffer ,buffer}))

(fn vmap! [lhrs rhs buffer]
  `(vim.keymap.set :v ,lhs ,rhs {:noremap true :silent true :buffer ,buffer}))

(fn xmap! [lhrs rhs buffer]
  `(vim.keymap.set :x ,lhs ,rhs {:noremap true :silent true :buffer ,buffer}))

(fn map! [modes lhrs rhs buffer]
  `(vim.keymap.set ,modes ,lhs ,rhs {:noremap true :silent true :buffer ,buffer}))

(fn req! [lib val]
  `(. (require ,lib) ,val))

(fn command! [name command opts]
  (let [o (if (= opts nil) {} opts)]
    `(vim.api.nvim_create_user_command ,name ,command ,o)))

{: nmap! : vmap! : req! : map! : command! : xmap!}
