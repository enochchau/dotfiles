call plug#begin('~/.config/plugged')
" themes
" Plug 'morhetz/gruvbox'
" Plug 'overcache/NeoSolarized'
" Plug 'ayu-theme/ayu-vim'
Plug 'rakr/vim-one'
" Plug 'NLKNguyen/papercolor-theme'
" Plug 'kaicataldo/material.vim', {'branch':'main'}
" Plug 'rose-pine/neovim'
" zenbones
" Plug 'mcchrish/zenbones.nvim'
" Plug 'rktjmp/lush.nvim'


" syntax
Plug 'mtdl9/vim-log-highlighting'
Plug 'yuezk/vim-js'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'HerringtonDarkholme/yats.vim' " for tsx

Plug 'tpope/vim-commentary'
Plug 'suy/vim-context-commentstring'
Plug 'mhinz/vim-startify'
Plug 'tpope/vim-fugitive'
Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }
Plug 'lbrayner/vim-rzip'

if has('nvim')
  " telescope
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
  Plug 'fannheyward/telescope-coc.nvim'
  " treesitter
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'windwp/nvim-ts-autotag'

  Plug 'hoob3rt/lualine.nvim'
  Plug 'lukas-reineke/indent-blankline.nvim'
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'kyazdani42/nvim-tree.lua'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
endif
call plug#end()

source ~/.config/nvim/settings.vim
source ~/.config/nvim/theme.vim
source ~/.config/nvim/syntax.vim
source ~/.config/nvim/doge.vim
source ~/.config/nvim/coc.vim
if has('nvim')
  source ~/.config/nvim/treesitter.vim
  source ~/.config/nvim/tree.vim
  source ~/.config/nvim/telescope.vim
  source ~/.config/nvim/lualine.vim
  source ~/.config/nvim/blankline.vim
endif
