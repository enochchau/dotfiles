call plug#begin('~/.config/plugged')
Plug 'morhetz/gruvbox'
Plug 'overcache/NeoSolarized'
Plug 'ayu-theme/ayu-vim'
Plug 'rakr/vim-one'
Plug 'NLKNguyen/papercolor-theme'

Plug 'tpope/vim-commentary'
Plug 'kaicataldo/material.vim', {'branch':'main'}
Plug 'mtdl9/vim-log-highlighting'
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'mhinz/vim-startify'
Plug 'tpope/vim-fugitive'

if has('nvim')
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'hoob3rt/lualine.nvim'
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'kyazdani42/nvim-tree.lua'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
endif
call plug#end()

source ~/.config/nvim/settings.vim
source ~/.config/nvim/theme.vim
source ~/.config/nvim/treesitter.vim
source ~/.config/nvim/tree.vim
source ~/.config/nvim/coc.vim
source ~/.config/nvim/fuzzy.vim
source ~/.config/nvim/lualine.vim
