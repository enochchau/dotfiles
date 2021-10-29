nnoremap <C-p> <cmd>Telescope find_files<cr> <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <C-f> <cmd>Telescope live_grep<cr> <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <C-b> <cmd>Telescope buffers<cr> <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
lua << EOF
local telescope  = require('telescope')

telescope.load_extension('fzf')
telescope.load_extension('coc')
telescope.setup()
EOF
