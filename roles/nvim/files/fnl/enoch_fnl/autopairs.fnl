(local nvim-autopairs (require :nvim-autopairs))
(local cmp-autopairs (require :nvim-autopairs.completion.cmp))
(local cmp (require :cmp))

(cmp.event:on :confirm_done
              (cmp_autopairs.on_confirm_done {:map_char {:text ""}}))

(nvim-autopairs.setup {:check_ts true})
