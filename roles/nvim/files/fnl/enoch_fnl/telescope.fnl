(local telescope (require :telescope))
(local themes (require :telescope.themes))
(local actions (require :telescope.actions))
(local {: nnoremap} (require :enoch_fnl.helpers))

(fn cursor-theme []
  (let [base (themes.get_dropdown)]
    (tset base :layout_strategy :cursor)
    base))

(telescope.setup {:extensions {:fzf {:fuzzy true
                                     :override_generic_sorter true
                                     :override_file_sorter true}
                               :ui-select [(cursor-theme)]}
                  :pickers {:buffers {:mappings {:n {:dd actions.delete_buffer}}}}})

(telescope.load_extension :fzf)
(telescope.load_extension :ui-select)
(nnoremap :<C-p> "<cmd>Telescope find_files<CR>")
(nnoremap :<C-f> "<cmd>Telescope live_grep<CR>")
(nnoremap :<C-b> "<cmd>Telescope buffers<CR>")
(nnoremap :<leader>fh "<cmd>Telescope help_tags<CR>")
