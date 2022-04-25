(local treesitter (require :nvim-treesitter.configs))
(let [languages [:bash
                 :comment
                 :css
                 :dockerfile
                 :dot
                 :fennel
                 :go
                 :graphql
                 :html
                 :javascript
                 :jsdoc
                 :json
                 :jsonc
                 :julia
                 :lua
                 :nix
                 :query
                 :regex
                 :scss
                 :svelte
                 :tsx
                 :typescript
                 :vim
                 :yaml
                 :zig]]
  (treesitter.setup {:ensure_installed languages
                     :highlight {:enable true
                                 :additional_vim_regex_highlighting false}
                     :autotag {:enable true}
                     :context_commentstring {:enable true
                                             :enable_autocmd false}}))
