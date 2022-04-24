(local nvim-tree (require :nvim-tree))
(local {: nnoremap} (require :enoch_fnl.helpers))

(nvim-tree.setup {:open_on_setup false
                  :update_cwd true
                  :view {:side :right
                         :auto_resize true
                         :width 35
                         :relativenumber true
                         :signcolumn :auto}
                  :git {:enable true :ignore false}
                  :filters {:custom [:.DS_Store]}})

(nnoremap :<leader>n ":NvimTreeFindFile<CR>")
(nnoremap :<C-n> ":NvimTreeToggle<CR>")
(nnoremap :<leader>r ":NvimTreeRefresh<CR>")
nil
