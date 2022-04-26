(local toggleterm (require :toggleterm))

(let [opts {:open_mapping "<c-\\>"}]
  (if (= vim.g.colors_name :gruvbox) (tset opts :shading_factor 5))
  (if (= vim.g.colors_name :onedark) (tset opts :shading_factor 3))
  (toggleterm.setup opts))
