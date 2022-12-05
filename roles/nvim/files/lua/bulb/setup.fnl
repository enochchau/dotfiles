(macro setup-command [cmd]
  `(fn []
     (do
       (activate-cmd)
       ,cmd)))

(fn tapped-macro-searcher [module-name]
  "Tap into the default fnl macro searcher to do caching"
  (let [fennel (require :bulb.fennel)
        {: add-macro} (require :bulb.cache)
        default-macro-searcher (. fennel.macro-searchers 1)
        (result filename) (default-macro-searcher module-name)]
    ;; add the macro to our cache
    (add-macro filename module-name (string.dump result))
    (values result filename)))

(fn activate-cmd []
  "Setup the fennel<->nvim compiler enviorment"
  (let [fennel (require :bulb.fennel)
        {: update-fnl-macro-rtp} (require :bulb)]
    ;; check the macro searcher
    (if (not= (. fennel.macro-searchers 1) tapped-macro-searcher)
        (tset fennel.macro-searchers 1 tapped-macro-searcher))
    (if (not= debug.traceback fennel.traceback)
        (tset debug :traceback fennel.traceback))
    (update-fnl-macro-rtp)))

(fn setup [user-config]
  "Setup bulb"
  (let [config (require :bulb.config)
        command vim.api.nvim_create_user_command]
    ;; apply user configs
    (tset config :cfg (vim.tbl_deep_extend :keep user-config config.cfg))
    ;; create user commands
    (command :BulbCompile
             (setup-command (. (require :bulb.commands)) :headless-compile)
             {:nargs "+"})
    (command :BulbRun
             (setup-command (. (require :bulb.commands)) :headless-run)
             {:nargs 1})
    (command :BulbPreload
             (setup-command (. (require :bulb.cache)) :gen-preload-cache) {})))

{: setup}
