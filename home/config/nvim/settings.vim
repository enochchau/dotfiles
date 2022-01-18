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
set hidden
set updatetime=300

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

" set autoindent
" set smartindent

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
" https://github.com/neovim/neovim/issues/9570030.964%20%20000.026%20%20000.026:%20sourcing%20/home/enoch/.config/plugged/nvim-treesitter/ftdetect/gdresource.vim
if has('wsl')
  let g:clipboard = {
    \ 'name': 'win32yank',
    \ 'copy': {
    \    '+': 'win32yank.exe -i --crlf',
    \    '*': 'win32yank.exe -i --crlf',
    \  },
    \ 'paste': {
    \    '+': 'win32yank.exe -o --lf',
    \    '*': 'win32yank.exe -o --lf',
    \ },
    \ 'cache_enabled': 0,
    \ }
elseif has('mac')
  let g:clipboard = {
    \ 'name': 'pbcopy',
    \ 'copy': {
    \    '+': 'pbcopy',
    \    '*': 'pbcopy',
    \  },
    \ 'paste': {
    \    '+': 'pbpaste',
    \    '*': 'pbpaste',
    \ },
    \ 'cache_enabled': 0,
    \ }
endif
set clipboard+=unnamedplus

" traverse buffers
noremap <silent> ]b :bnext<CR>
noremap <silent> [b :bprevious<CR>

" terminal remap
tnoremap <Esc> <C-\><C-n>

" relative line numbers
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave,WinEnter * if &nu && mode() != "i" | set rnu   | endif
  autocmd BufLeave,FocusLost,InsertEnter,WinLeave   * if &nu                  | set nornu | endif
augroup END

" color column at 80
set colorcolumn=120

" disable startup screen
set shortmess+=I
