(fn tap-macro-searcher []
  "Tap into the default fnl macro searcher to do caching"
  (if (not _G.__bulb_internal.macro_searcher_updated)
      (let [{: add-macro} (require :bulb.cache)
            fennel (require :bulb.fennel)
            _macro-searcher (. fennel.macro-searchers 1)
            tapped-searcher (fn [module-name]
                              (let [(result filename) (_macro-searcher module-name)]
                                (add-macro filename module-name
                                           (string.dump result))
                                (values result filename)))]
        (tset fennel.macro-searchers 1 tapped-searcher)
        (tset _G.__bulb_internal :macro_searcher_updated true))))

(fn enable-debug []
  "Enable fennel debug mode"
  (let [fennel (require :bulb.fennel)]
    (if (not= debug.traceback fennel.traceback)
        (tset debug :traceback fennel.traceback))))

(fn setup [user-config]
  "Setup bulb"
  (let [config (require :bulb.config)
        command vim.api.nvim_create_user_command
        user-config (or user-config {})
        {: update-fnl-macro-rtp} (require :bulb.lutil)]
    ;; apply user configs
    (tset config :cfg (vim.tbl_deep_extend :keep user-config config.cfg))
    ;; setup
    (update-fnl-macro-rtp)
    (tap-macro-searcher)
    (enable-debug)
    ;; create user commands
    (command :BulbCompile (. (require :bulb.headless) :headless-compile)
             {:nargs "+"})
    (command :BulbRun (. (require :bulb.headless) :headless-run) {:nargs 1})
    (command :BulbPreload (. (require :bulb.cache) :gen-preload-cache) {})))

{: setup}
