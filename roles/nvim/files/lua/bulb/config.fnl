{:cfg {;; compiler options
       :compiler-options {}
       ;; whether to attach fennel's debug.traceback
       :debug false
       :bootstrap false
       ;; path to store compiled file at
       :cache-path (.. (vim.fn.stdpath :config) :/plugin/bulb_preload.lua)}}
