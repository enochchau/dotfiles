(local alpha (require :alpha))
(local startify (require :alpha.themes.startify))
(local get-fortune (require :alpha.fortune))

(fn say-fortune [art]
  (let [fortune (get-fortune)]
    (each [_index str (ipairs art)]
      (table.insert fortune str))
    fortune))

(fn cowsays-fortune []
  (let [says ["                         "
              "    o                    "
              "     o   ^__^            "
              "      o  (oo)\\_______    "
              "         (__)\\       )\\/\\"
              "             ||----w |   "
              "             ||     ||   "]]
    (say-fortune says)))

(fn tuxsays-fortune []
  (let [says ["    o              "
              "     o     .--.    "
              "      o   |o_o |   "
              "          |:_/ |   "
              "         //   \\ \\  "
              "        (|     | ) "
              "       /'\\_   _/`\\ "
              "       \\___)=(___/ "]]
    (say-fortune says)))

(let [header (cowsays-fortune)]
  (tset startify.section.header :val header)
  (alpha.setup startify.config))
