(local nmap (. (require :enoch.helpers) :nmap))

(macro fterm-cmd! [name]
  (let [cmd (string.gsub name "^%l" string.upper)]
    `(vim.api.nvim_create_user_command ,cmd (. (require :FTerm) ,name)
                                       {:bang true})))

(nmap "<C-\\>" (. (require :FTerm) :toggle))
(fterm-cmd! :open)
(fterm-cmd! :close)
(fterm-cmd! :exit)
(fterm-cmd! :toggle)
