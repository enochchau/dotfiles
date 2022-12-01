(macro get-quotes! [filename]
  (fn json-read [filename]
    "Read a json file as a table"
    (-> filename
        (vim.fn.expand)
        (vim.fn.readfile)
        (vim.fn.json_decode)))

  (fn split-80 [str]
    "Split a string at 80 if it's more than 80 chars"
    [(string.sub str 1 80) (-> str (string.sub 81) (vim.trim))])

  (fn format-quote [q]
    "Format a quote into a table of strings"
    (let [msg (icollect [_ str (ipairs (vim.fn.split q.quote "\n"))]
                (if (> (length str) 80)
                    (split-80 str)
                    str))]
      (table.insert msg (.. "- " q.author))
      (vim.tbl_flatten msg)))

  (let [quotes (json-read filename)]
    (icollect [_ q (ipairs quotes)]
      (format-quote q))))

(fn rand-quote []
  "Returns a random quote"
  (math.randomseed (os.time))
  (let [quotes (get-quotes! "~/.config/nvim/quotes.json")
        rand (math.random 1 (length quotes))]
    (. quotes rand)))

{: rand-quote}
