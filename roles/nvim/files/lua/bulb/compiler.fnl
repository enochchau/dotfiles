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

{: compile-file : do-file}
