{:cfg {;; compiler options
       :compiler-options {:compilerEnv _G}
       ;; path to store compiled file at
       :cache-path (.. (vim.fn.stdpath :config) :/plugin/bulb_preload.lua)}}
