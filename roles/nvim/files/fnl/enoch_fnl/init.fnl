(require :enoch_fnl.alpha)
(require :enoch_fnl.autopairs)
(require :enoch_fnl.cmp)
(require :enoch_fnl.format)
(require :enoch_fnl.blankline)
(require :enoch_fnl.git)
(require :enoch_fnl.filetree)
(require :enoch_fnl.statusline)
(require :enoch_fnl.term)
(require :enoch_fnl.treesitter)
(require :enoch_fnl.telescope)
(require :enoch_fnl.lsp)

(local augroup vim.api.nvim_create_augroup)
(local autocmd vim.api.nvim_create_autocmd)
(local fidget (require :fidget))
(local leap (require :leap))

(fidget.setup)
(leap.set_default_keymaps)

;; set comment string for fennel
(let [comment-string (augroup :CommentString {})]
  (autocmd :FileType
           {:group comment-string
            :pattern [:fennel]
            :callback (fn []
                        (tset vim.opt_local :commentstring ";; %s"))}))
