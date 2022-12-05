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

(fn compile-file [filename]
  "Compile a file stream"
  (let [fennel (require :bulb.fennel)
        {: cfg} (require :bulb.config)]
    (fennel.compile-stream (stream-file filename) cfg.compiler-options)))

(fn do-file [filename]
  "Evaluate a file"
  (let [fennel (require :bulb.fennel)
        {: cfg} (require :bulb.config)]
    (fennel.do-file filename cfg.compiler-options)))

{: compile-file : do-file}
