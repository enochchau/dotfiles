(local telescope (require :telescope))
(local actions (require :telescope.actions))
(local {: nnoremap} (require :enoch_fnl.helpers))

(let [code_actions_config {:layout_strategy :cursor
                           :layout_config {:width 0.45 :height 0.25}}]
  (telescope.setup {:extensions {:fzf {:fuzzy true
                                       :override_generic_sorter true
                                       :override_file_sorter true}}
                    :pickers {:buffers {:mappings {:n {:dd actions.delete_buffer}}}
                              :lsp_code_actions code_actions_config
                              :lsp_range_code_actions code_actions_config}})
  (telescope.load_extension :fzf)
  (nnoremap :<C-p> "<cmd>Telescope find_files<CR>")
  (nnoremap :<C-f> "<cmd>Telescope live_grep<CR>")
  (nnoremap :<C-b> "<cmd>Telescope buffers<CR>")
  (nnoremap :<leader>fh "<cmd>Telescope help_tags<CR>"))
