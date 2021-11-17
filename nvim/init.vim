call plug#begin('~/.config/plugged')
" themes
" Plug 'rakr/vim-one'
" Plug 'morhetz/gruvbox'
" Plug 'overcache/NeoSolarized'
" Plug 'ayu-theme/ayu-vim'
" Plug 'NLKNguyen/papercolor-theme'
Plug 'kaicataldo/material.vim', {'branch':'main'}
" Plug 'rose-pine/neovim'
" Plug 'mcchrish/zenbones.nvim'
" Plug 'rktjmp/lush.nvim' " for zenbones

" Syntax
Plug 'pangloss/vim-javascript'
Plug 'HerringtonDarkholme/yats.vim'
Plug 'styled-components/vim-styled-components'

Plug 'suy/vim-context-commentstring'
Plug 'mhinz/vim-startify'
Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
Plug 'AndrewRadev/tagalong.vim'

if has('nvim')
  " telescope
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
  Plug 'fannheyward/telescope-coc.nvim'

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
source ~/.config/nvim/syntax.vim
source ~/.config/nvim/doge.vim
source ~/.config/nvim/coc.vim
source ~/.config/nvim/markdown-preview.vim
if has('nvim')
  source ~/.config/nvim/tree.vim
  source ~/.config/nvim/telescope.vim
  source ~/.config/nvim/lualine.vim
  source ~/.config/nvim/blankline.vim
endif
