(fn gen-map [modes]
  "Generator function to create key mapping functions"
  (fn [lhs rhs buffer]
    (vim.keymap.set modes lhs rhs {:noremap true :silent true : buffer})))

{:nmap (gen-map :n)
 :vmap (gen-map :v)
 :xmap (gen-map :x)
 :tmap (gen-map :t)
 :map (fn [modes lhs rhs buffer]
        ((gen-map modes) lhs rhs buffer))}
