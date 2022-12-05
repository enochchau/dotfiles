;; functions for commands in headless mode

(fn write-file [filename contents]
  "write a file to disk"
  (let [file (assert (io.open filename :w))]
    (file:write contents)
    (file:close)))

(fn headless-compile [t]
  (let [{: compile-file} (require :bulb.compiler)
        {: print-stdout} (require :bulb.utils)
        (in-path out-path) (unpack t.fargs)]
    (assert in-path "Missing input path")
    (let [output (compile-file in-path)]
      (if (= nil out-path) (print-stdout output) (write-file out-path output)))))

(fn headless-run [t]
  (let [{: do-file} (require :bulb.compiler)
        {: print-stdout} (require :bulb.utils)
        fennel (require :bulb.fennel)
        in-path t.args]
    (assert in-path "Missing input path")
    (let [output (do-file in-path)]
      ;; seperate input from dofile stdout with a newline
      (print "\n")
      (print-stdout (fennel.view output)))))

{: headless-compile : headless-run}
