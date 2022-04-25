(local fmt-select (require :nvim-format-select))
(local augroup vim.api.nvim_create_augroup)
(local autocmd vim.api.nvim_create_autocmd)

(fn fmt-eslint []
  (fmt-select.formatting_sync_select :eslint {} 3000))

(fn format-js []
  (let [path (vim.fn.expand "%:p")]
    (if (string.match path :Gatsby/repo) (fmt-eslint)
        (vim.lsp.buf.formatting_seq_sync {} 3000 [:null-ls :eslint]))))

(fn format-default []
  (vim.lsp.buf.formatting_sync {} 3000))

(let [fmt-on-save (augroup :FmtOnSave [])]
  (autocmd :BufWritePre {:group fmt-on-save
                         :pattern [:*.css
                                   :*.scss
                                   :*.md
                                   :*.go
                                   :*.yaml
                                   :*.yml
                                   :*.json
                                   :*.lua
                                   :*.fnl]
                         :callback format-default})
  (autocmd :BufWritePre {:group fmt-on-save
                         :pattern [:*.js :*.ts :*.jsx :*.tsx]
                         :callback format-js}))
