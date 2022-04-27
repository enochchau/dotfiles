(local onedark (require :onedark))

(fn colo [theme]
  (vim.cmd (.. "colo " theme)))

(onedark.load)

;; theme configs
(set vim.opt.bg :light)
(set vim.g.neon_style :light)
(set vim.g.gruvbox_contrast_light :light)
(set vim.g.tokyonight_style :day)

;; (colo :neon)
(colo :tokyonight)
;; (colo :onedark)
