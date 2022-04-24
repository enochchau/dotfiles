(local lualine (require :lualine))

(fn get-theme []
  (let [theme vim.g.colors_name]
    (if (= theme :one) (:onedark) theme)))

(lualine.setup {:sections {:lualine_b [:branch
                                       "b:gitsigns_status"
                                       {1 :diagnostics
                                        :sources [:nvim_diagnostic]}]
                           :lualine_c ["%{ObsessionStatus('', '')}"
                                       :filename]}
                :options {:theme (get-theme)
                          :section_separators ""
                          :component_separators "|"}
                :extensions [:nvim-tree :toggleterm]})
