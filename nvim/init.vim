call plug#begin('~/.config/plugged')
" Fuzzy finder
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
" Commenting
Plug 'tpope/vim-commentary'
" Themes
Plug 'kaicataldo/material.vim', {'branch':'main'}
Plug 'morhetz/gruvbox'
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

so ~/.config/nvim/settings.vim
so ~/.config/nvim/theme.vim
so ~/.config/nvim/treesitter.vim
so ~/.config/nvim/tree.vim
so ~/.config/nvim/coc.vim
so ~/.config/nvim/fuzzy.vim
