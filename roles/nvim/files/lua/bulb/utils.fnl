(fn print-stdout [msg]
  "Print a message to stdout when running in headless mode"
  (let [msg (vim.fn.split msg "\n")]
    (vim.fn.writefile msg :/dev/stdout)))

{: print-stdout}
