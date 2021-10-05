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
Plug 'rakr/vim-one'
" Statusline
Plug 'hoob3rt/lualine.nvim'
" File Tree
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'
" Syntax Highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" blank lines
Plug 'lukas-reineke/indent-blankline.nvim'
" COC
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Startify
Plug 'mhinz/vim-startify'
" Git
Plug 'tpope/vim-fugitive'
call plug#end()

source ~/.config/nvim/settings.vim
source ~/.config/nvim/theme.vim
source ~/.config/nvim/treesitter.vim
source ~/.config/nvim/tree.vim
source ~/.config/nvim/coc.vim
source ~/.config/nvim/fuzzy.vim
source ~/.config/nvim/lualine.vim
