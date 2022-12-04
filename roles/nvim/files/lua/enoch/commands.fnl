(import-macros {: req! : command!} :macros)

(macro command-fterm! [name]
  (let [cmd (.. :FTerm (string.gsub name "^%l" string.upper))]
    `(vim.api.nvim_create_user_command ,cmd (. (require :FTerm) ,name)
                                       {:bang true})))

;; Clear all but the current buffer
(command! :BufClear "%bd|e#|bd#")

;; Format cmd
(command! :Format #((req! :enoch.format :format) vim.bo.filetype._value))

;; swap nu to rnu and visa versa
(command! :SwapNu #(set vim.opt.relativenumber
                        (not vim.opt.relativenumber._value)))

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
    (macro sys-open-url [sys-cmd url]
      (fn step [i]
        (if (<= i (length sys-cmd))
            (let [(sys cmd) (unpack (. sys-cmd i))]
              `(if (= (vim.fn.has ,sys) 1) (vim.fn.system (.. ,cmd " " ,url))
                   ,(step (+ i 1))))))

      (step 1))
    (sys-open-url [[:mac :open]
                   [:wsl :explorer.exe]
                   [:win32 :start]
                   [:linux :xdg-open]] url))

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

;; Run a buffer
(command! :Run #(let [runners {:fennel [(vim.fn.expand "~/.config/nvim/scripts/fnl-nvim")
                                        :-e]
                               :javascript [:node]
                               :lua [:lua]}
                      buf (vim.api.nvim_buf_get_name 0)
                      ft (vim.filetype.match {:filename buf})
                      exec (. runners ft)]
                  (if (not= nil exec)
                      (do
                        (table.insert exec buf)
                        ((req! :FTerm :scratch) {:cmd exec}))))
          {:bang true})
