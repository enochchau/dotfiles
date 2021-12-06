call plug#begin('~/.config/plugged')
" themes
Plug 'rakr/vim-one'
" Plug 'folke/tokyonight.nvim'
" Plug 'mhartington/oceanic-next'
" Plug 'morhetz/gruvbox'
" Plug 'NLKNguyen/papercolor-theme'
" Plug 'kaicataldo/material.vim', {'branch':'main'}
" Plug 'mcchrish/zenbones.nvim'
" Plug 'rktjmp/lush.nvim' " for zenbones

Plug 'editorconfig/editorconfig-vim'
Plug 'mhinz/vim-startify'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }

if has('nvim')
  " telescope
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
  Plug 'fannheyward/telescope-coc.nvim'
  " tree-sitter
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'windwp/nvim-ts-autotag'
  Plug 'JoosepAlviste/nvim-ts-context-commentstring'

  Plug 'akinsho/toggleterm.nvim'
  Plug 'b3nj5m1n/kommentary'
  Plug 'hoob3rt/lualine.nvim'
  Plug 'lukas-reineke/indent-blankline.nvim'
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'kyazdani42/nvim-tree.lua'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
endif
call plug#end()

source ~/.config/nvim/settings.vim
source ~/.config/nvim/theme.vim
source ~/.config/nvim/coc.vim
source ~/.config/nvim/markdown-preview.vim
if has('nvim')
  source ~/.config/nvim/treesitter.vim
  source ~/.config/nvim/kommentary.vim
  source ~/.config/nvim/tree.vim
  source ~/.config/nvim/telescope.vim
  source ~/.config/nvim/lualine.vim
  source ~/.config/nvim/blankline.vim
  source ~/.config/nvim/toggleterm.vim
endif
