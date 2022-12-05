(fn setup [user-config]
  "Setup bulb"
  (let [config (require :bulb.config)
        command vim.api.nvim_create_user_command
        user-config (or user-config {})]
    ;; apply user configs
    (tset config :cfg (vim.tbl_deep_extend :keep user-config config.cfg))
    ;; create user commands
    (command :BulbCompile (. (require :bulb.headless) :headless-compile)
             {:nargs "+"})
    (command :BulbRun (. (require :bulb.headless) :headless-run) {:nargs 1})
    (command :BulbPreload (. (require :bulb.cache) :gen-preload-cache) {})))

{: setup}
