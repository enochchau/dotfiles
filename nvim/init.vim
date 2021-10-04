call plug#begin('~/.config/plugged')
" Fuzzy finder
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
" Commenting
Plug 'tpope/vim-commentary'
" Themes
Plug 'kaicataldo/material.vim', {'branch':'main'}
Plug 'morhetz/gruvbox'
Plug 'overcache/NeoSolarized'
Plug 'ayu-theme/ayu-vim'
" Airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" File Tree
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'
" Syntax Highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" blank lines
Plug 'lukas-reineke/indent-blankline.nvim'
" COC
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

source ~/.config/nvim/settings.vim
source ~/.config/nvim/theme.vim
source ~/.config/nvim/treesitter.vim
source ~/.config/nvim/tree.vim
source ~/.config/nvim/coc.vim
source ~/.config/nvim/fuzzy.vim
source ~/.config/nvim/airline.vim
