;; I read somewhere streaming is supposed to use less memory
(fn stream-file [filename]
  "Open a file as a read stream"
  (let [file-handle (assert (io.open filename :rb))]
    (fn []
      (let [char (file-handle:read 1)]
        (if (not= nil char) (char:byte)
            (do
              (file-handle:close)
              nil))))))

(fn get-compiler-options [filename]
  (let [{: cfg} (require :bulb.config)]
    (vim.tbl_extend :keep cfg.compiler-options {: filename})))

(fn compile-file [filename]
  "Compile a file"
  (let [fennel (require :bulb.fennel)
        compiler-options (get-compiler-options filename)]
    (fennel.compile-stream (stream-file filename) compiler-options)))

(fn do-file [filename]
  "Evaluate a file"
  (let [fennel (require :bulb.fennel)
        compiler-options (get-compiler-options filename)]
    (fennel.dofile filename compiler-options)))

(fn tapped-macro-searcher [module-name]
  "Tap into the default fnl macro searcher to do caching"
  (let [fennel (require :bulb.fennel)
        {: add-macro} (require :bulb.cache)
        default-macro-searcher (. fennel.macro-searchers 1)
        (result filename) (default-macro-searcher module-name)]
    ;; add the macro to our cache
    (add-macro filename module-name (string.dump result))
    (values result filename)))

(fn activate-compiler-env []
  "Setup the fennel<->nvim compiler enviorment"
  (let [fennel (require :bulb.fennel)
        {: update-fnl-macro-rtp} (require :bulb.lutil)]
    ;; check the macro searcher
    (if (not= (. fennel.macro-searchers 1) tapped-macro-searcher)
        (tset fennel.macro-searchers 1 tapped-macro-searcher))
    (if (not= debug.traceback fennel.traceback)
        (tset debug :traceback fennel.traceback))
    (update-fnl-macro-rtp)))


{: compile-file : do-file : activate-compiler-env}
