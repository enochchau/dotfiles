(import-macros {: req! : command!} :macros)

(macro command-fterm! [name]
  (let [cmd (.. :FTerm (string.gsub name "^%l" string.upper))]
    `(vim.api.nvim_create_user_command ,cmd (. (require :FTerm) ,name)
                                       {:bang true})))

;; Clear all but the current buffer
(command! :BufClear "%bd|e#|bd#")

;; Format cmd
(command! :Format #((req! :enoch.format :format) vim.opt_local.filetype))

;; swap nu to rnu and visa versa
(command! :SwapNu #(set opt.relativenumber (not opt.relativenumber._value)))

;; FTerm
(command-fterm! :open)
(command-fterm! :close)
(command-fterm! :exit)
(command-fterm! :toggle)

(command! :Cdg #(vim.api.nvim_set_current_dir (vim.trim (vim.fn.system "git rev-parse --show-toplevel"))))
