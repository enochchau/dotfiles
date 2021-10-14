let mapleader = ","
set signcolumn=yes:1
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
noremap <silent> <A-h> <C-w><
noremap <silent> <A-j> <C-W>-
noremap <silent> <A-k> <C-W>+
noremap <silent> <A-l> <C-w>>

" auto resize
autocmd VimResized * wincmd =

" use system clipboard
set clipboard+=unnamedplus

" traverse buffers
" noremap <silent> ]b :bnext<CR>
" noremap <silent> [b :bprevious<CR>
