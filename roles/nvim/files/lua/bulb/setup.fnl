(fn tap-macro-searcher []
  (let [fennel (require :bulb.fennel)
        default-macro-searcher (. fennel.macro-searchers 1)]
    (fn tapped-searcher [module-name]
      "Tap into the default macro searcher to do caching"
      (let [(result filename) (default-macro-searcher module-name)]
        ;; TODO: implement caching for macros
        (print "Found Macro:" filename)
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
    ;; TODO: tap into regular fnl searcher as well!
    (tap-macro-searcher)
    ;; create user commands
    (command :FnlCompile (. (require :bulb.headless) :headless-compile)
             {:nargs "+"})
    (command :FnlRun (. (require :bulb.headless) :headless-run) {:nargs 1})))

{: setup}
