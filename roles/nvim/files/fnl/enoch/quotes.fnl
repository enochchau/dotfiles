(fn json-read [filename]
  "Read a json file as a table"
  (let [f (vim.fn.expand filename)]
    (vim.fn.json_decode (vim.fn.readfile f))))

(fn rand-quote []
  "Returns a random quote"
  (math.randomseed (os.time))
  (let [quotes (json-read "~/.config/nvim/quotes.json")
        rand (math.random 1 (length quotes))
        q (. quotes rand)
        msg []
        split-80 (fn [str]
                   "Split a string at 80 if it's more than 80 chars"
                   (table.insert msg (string.sub str 1 80))
                   (table.insert msg (vim.trim (string.sub str 81))))]
    (each [_ str (ipairs (vim.fn.split q.quote "\n"))]
      (if (> (length str) 80)
          (split-80 str)
          (table.insert msg str)))
    (table.insert msg (.. "- " q.author))
    msg))

{: rand-quote}
