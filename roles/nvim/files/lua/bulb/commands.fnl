;; functions for commands in headless mode

(fn headless-compile [t]
  "Command for compiling a file in headless mode"
  (let [{: compile-file} (require :bulb.compiler)
        {: print-stdout} (require :bulb.utils)
        {: write-file} (require :bulb.fs)
        (in-path out-path) (unpack t.fargs)]
    (assert in-path "Missing input path")
    (let [output (compile-file in-path)]
      (if (= nil out-path) (print-stdout output) (write-file out-path output)))))

(fn headless-run [t]
  "Command for running a file in headless mode"
  (let [{: do-file} (require :bulb.compiler)
        {: print-stdout} (require :bulb.utils)
        fennel (require :bulb.fennel)
        in-path t.args]
    (assert in-path "Missing input path")
    (let [output (do-file in-path)]
      ;; seperate input from dofile stdout with a newline
      (print "\n")
      (print-stdout (fennel.view output)))))

(fn gen-preload-cache []
  "Generate the preload file for all the files in the first runtime path"
  (let [{: get-fnl-files} (require :bulb.fs)
        {: compile-file} (require :bulb.compiler)
        {: add-module : write-cache} (require :bulb.cache)
        {: get-module-name} (require :bulb)
        fnl-files (get-fnl-files (vim.fn.stdpath :config))]
    (each [_ filename (ipairs fnl-files)]
      (let [module-name (get-module-name filename)]
        (if (not= nil module-name)
            (->> (compile-file filename) (add-module filename module-name)))))
    (write-cache)))

{: headless-compile : headless-run : gen-preload-cache}
