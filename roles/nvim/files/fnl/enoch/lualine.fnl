(fn get-theme [theme]
  (if (= theme :one) :onedark
      (= theme :github_dark) :github
      theme))

(let [theme (get-theme vim.g.colors_name)
      lualine (require :lualine)]
  (lualine.setup {:sections {:lualine_b [:branch
                                         "b:gitsigns_status"
                                         {1 :diagnostics
                                          :sources [:nvim_diagnostic]}]
                             :lualine_c ["%{ObsessionStatus('', '')}"
                                         :filename]}
                  :options {: theme
                            :section_separators ""
                            :component_separators "|"}
                  :extensions [:nvim-tree :toggleterm]})
  nil)
