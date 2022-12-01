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

(command! :Cdg #(-> (vim.fn.system "git rev-parse --show-toplevel")
                    (vim.trim)
                    (vim.api.nvim_set_current_dir)))

(fn open-plugin-link []
  "Open a plugin under the cursor in ./plugin.lua in the browser"
  (local ts_utils (require :nvim-treesitter.ts_utils))

  (fn open-url [url]
    "Open a url in the browser"
    (let [has vim.fn.has
          system vim.fn.system]
      (if (has :mac) (system (.. "open " url))
          (has :wsl) (system (.. "explorer.exe " url))
          (has :win32) (system (.. "start " url))
          (has :linux) (system (.. "xdg-open " url)))))

  (fn get-text-at-cursor []
    "Get text under cursor"
    (-> (ts_utils.get_node_at_cursor)
        (vim.treesitter.query.get_node_text 0)
        (string.gsub "^[\"'](.*)[\"']$" "%1")))

  (fn url? [url]
    "Check that the string is a url"
    (url:match "^https://"))

  (fn github? [str]
    "Check if the plugin string is a github string"
    (str:match "^([a-zA-Z0-9-_.]+)/([a-zA-Z0-9-_.]+)$"))

  (let [text (get-text-at-cursor)]
    (if (url? text) (open-url text)
        (github? text) (open-url (.. "https://github.com/" text)))))

(command! :PackerOpen open-plugin-link)
