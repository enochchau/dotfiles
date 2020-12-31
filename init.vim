so ~/.config/nvim/plug.vim
so ~/.config/nvim/theme.vim
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

syntax enable
filetype plugin indent on

set tabstop=4
set expandtab
set shiftwidth=4
set softtabstop=4

set autoindent
set smartindent

set hlsearch

set cursorline
" set spell spelllang=en_us

vnoremap > >gv
vnoremap < <gv

" Autostart colorizer
" let g:colorizer_auto_color=1
