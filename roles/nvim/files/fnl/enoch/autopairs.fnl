(let [cmp_autopairs (require :nvim-autopairs.completion.cmp)
      cmp (require :cmp)
      nvim-autopairs (require :nvim-autopairs)]
  (nvim-autopairs.setup {:check_ts true})
  (cmp.event:on :confirm_done
                (cmp_autopairs.on_confirm_done {:map_char {:tex ""}}))
  nil)
