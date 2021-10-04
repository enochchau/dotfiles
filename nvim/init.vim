set number
set wrap
set encoding=utf-8
set mouse=a
set wildmenu
set lazyredraw
set showmatch
set laststatus=2
set ruler

" move vertically by visual line, don't skip wrapped lines
nmap j gj
nmap k gk

" enable syntax and filetype detection
syntax enable
filetype plugin indent on

" set tabs to 2 spaces
set tabstop=2
set expandtab
set shiftwidth=2
set softtabstop=2

set autoindent
set smartindent

" highlight all search pattern matches
set hlsearch

set cursorline
" set spell spelllang=en_us

" Hold visual mode after indent
vnoremap > >gv
vnoremap < <gv
" Maps Alt-[h,j,k,l] to resizing a window split
map <silent> <A-h> <C-w><
map <silent> <A-j> <C-W>-
map <silent> <A-k> <C-W>+
map <silent> <A-l> <C-w>>
" Mac specific alt
" https://stackoverflow.com/questions/7501092/can-i-map-alt-key-in-vim
map <silent> ˙ <C-w><
map <silent> ∆ <C-W>-
map <silent> ˚ <C-W>+
map <silent> ¬ <C-w>>

" use system clipboard
set clipboard=unnamedplus

" Autostart colorizer
" let g:colorizer_auto_color=1

so ~/.config/nvim/plug.vim
so ~/.config/nvim/theme.vim
so ~/.config/nvim/modern.vim
so ~/.config/nvim/treesitter.vim
so ~/.config/nvim/filetree.vim
so ~/.config/nvim/telescope.vim
