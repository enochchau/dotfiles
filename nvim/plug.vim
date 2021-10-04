call plug#begin('~/.config/plugged')
" Commenting
Plug 'tpope/vim-commentary'
" Themes
Plug 'kaicataldo/material.vim', {'branch':'main'}
Plug 'morhetz/gruvbox'
" Editing
Plug 'chrisbra/Colorizer'
" Plug 'mg979/vim-visual-multi', {'branch': 'master'}
" Plug 'jiangmiao/auto-pairs'

" File Tree
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'
" LSP
Plug 'neovim/nvim-lspconfig'
" Syntax Highlighting
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
" Autocomplete
Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
Plug 'windwp/nvim-autopairs'
" blank lines
Plug 'lukas-reineke/indent-blankline.nvim'
" fuzzy finder
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
call plug#end()
