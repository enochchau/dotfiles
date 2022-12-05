(fn print-stdout [msg]
  "Print a message to stdout when running in headless mode"
  (let [msg (vim.fn.split msg "\n")]
    (vim.fn.writefile msg :/dev/stdout)))

;; functions for commands in headless mode

(fn headless-compile [t]
  "Command for compiling a file in headless mode"
  (let [{: compile-file } (require :bulb.compiler)
        {: write-file} (require :bulb.fs)
        (in-path out-path) (unpack t.fargs)]
    (assert in-path "Missing input path")
    (let [output (compile-file in-path)]
      (if (= nil out-path) (print-stdout output) (write-file out-path output)))))

(fn headless-run [t]
  "Command for running a file in headless mode"
  (let [{: do-file } (require :bulb.compiler)
        fennel (require :bulb.fennel)
        in-path t.args]
    (assert in-path "Missing input path")
    (let [output (do-file in-path)]
      ;; seperate input from dofile stdout with a newline
      (print "\n")
      (print-stdout (fennel.view output)))))

{: headless-compile : headless-run}
