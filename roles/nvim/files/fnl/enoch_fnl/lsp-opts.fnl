(fn sumneko_lua []
  (let [runtime_path (vim.split package.path ";")
        root (vim.fn.getcwd)
        opt {:settings {:Lua {:telemetry {:enable false}}}}]
    (table.insert runtime_path :lua/?.lua)
    (table.insert runtime_path :lua/?/init.lua)
    (if (string.match root :nvim)
        ((fn []
           (tset opt.settings.Lua :runtime
                 {:version :LuaJIT :path runtime_path})
           (tset opt.settings.Lua :diagnostics {:globals [:vim]})
           (tset opt.settings.Lua :workspace
                 {:library (vim.api.nvim_get_runtime_file "" true)})))
        (string.match root :hammerspoon)
        ((fn []
           (tset opt.settings.Lua :workspace
                 {:library {:/Applications/Hammerspoon.app/Contents/Resources/extensions/hs/ true}})
           (tset opt.settings.Lua :diagnostics {:globals [:hs]}))))
    opt))

{: sumneko_lua}
