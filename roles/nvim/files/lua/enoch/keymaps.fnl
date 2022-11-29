(import-macros {: nmap! : vmap! : req!} :macros)

;; move vertically by visual line, don't skip wrapped lines
(nmap! :j :gj)
(nmap! :k :gk)

;; Hold visual mode after indent
(vmap! ">" :>gv)
(vmap! "<" :<gv)

;; Maps Alt-[h,j,k,l] to resizing a window split
(nmap! :<A-h> :<C-w><)
(nmap! :<A-j> :<C-w>-)
(nmap! :<A-k> :<C-w>+)
(nmap! :<A-l> :<C-w>>)

;; traverse buffers
(nmap! "]b" ":bnext<CR>")
(nmap! "[b" ":bprevious<CR>")

;; lsp
(nmap! :<leader>d #(vim.diagnostic.open_float nil {:focus false}))

;; telescope
(nmap! :<C-p> (req! :telescope.builtin :find_files))
(nmap! :<C-f> (req! :telescope.builtin :live_grep))
(nmap! :<C-b> (req! :telescope.builtin :buffers))
(nmap! :<leader>fh (req! :telescope.builtin :help_tags))
(nmap! :z= (req! :telescope.builtin :spell_suggest))
(nmap! :<leader>o (req! :telescope.builtin :jumplist))
(nmap! :<leader>cdg ":Telescope node-workspace<CR>")

;; neogen
(nmap! :<leader>nf (req! :neogen :generate))

;; window picker
(nmap! :<leader>w #(req! :nvim-window :pick))

;; Neotree
(nmap! :<leader>n ":NvimTreeFindFile<CR>")
(nmap! :<C-n> ":NvimTreeToggle<CR>")

;; FTerm
(nmap! "<C-\\>" (req! :FTerm :toggle))
