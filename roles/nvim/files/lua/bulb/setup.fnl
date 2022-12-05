(fn tap-macro-searcher []
  (let [fennel (require :bulb.fennel)
        default-macro-searcher (. fennel.macro-searchers 1)]
    (fn tapped-searcher [module-name]
      "Tap into the default fnl macro searcher to do caching"
      (let [(result filename) (default-macro-searcher module-name)]
        ;; TODO: implement caching for macros
        (vim.pretty_print "Found Macro:" filename result)
        (values result filename)))

    (tset fennel.macro-searchers 1 tapped-searcher)))

(fn setup [user-config]
  "Setup bulb"
  (let [fennel (require :bulb.fennel)
        config (require :bulb.config)
        command vim.api.nvim_create_user_command]
    ;; apply user configs
    (tset config :cfg (vim.tbl_deep_extend :keep user-config config.cfg))
    ;; attach traceback debugger if requested
    (if (and config.cfg.debug (not= debug.traceback fennel.traceback))
        (tset debug :traceback fennel.traceback))
    ;; tap into macro searcher
    (tap-macro-searcher)
    ;; create user commands
    (command :BulbCompile (. (require :bulb.commands) :headless-compile)
             {:nargs "+"})
    (command :BulbRun (. (require :bulb.commands) :headless-run) {:nargs 1})
    (command :BulbPreload (. (require :bulb.commands) :gen-preload-cache) {})))

{: setup}
