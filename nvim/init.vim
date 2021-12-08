call plug#begin('~/.config/plugged')
Plug 'rakr/vim-one'

Plug 'editorconfig/editorconfig-vim'
Plug 'mhinz/vim-startify'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' }
" yarn pnp
Plug 'lbrayner/vim-rzip'

if has('nvim')
  " telescope
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
  Plug 'fannheyward/telescope-coc.nvim'
  " tree-sitter
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'windwp/nvim-ts-autotag'
  Plug 'windwp/nvim-autopairs'
  " comment
  Plug 'JoosepAlviste/nvim-ts-context-commentstring'
  Plug 'b3nj5m1n/kommentary'
  " file tree
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'kyazdani42/nvim-tree.lua'
  " lsp
  Plug 'neoclide/coc.nvim', {'branch': 'release'}

  Plug 'lewis6991/gitsigns.nvim'
  Plug 'akinsho/toggleterm.nvim'
  Plug 'hoob3rt/lualine.nvim'
  Plug 'lukas-reineke/indent-blankline.nvim'
endif
call plug#end()

source ~/.config/nvim/settings.vim
source ~/.config/nvim/theme.vim
source ~/.config/nvim/markdown-preview.vim
if has('nvim')
  source ~/.config/nvim/coc.vim
  source ~/.config/nvim/gitsigns.vim
  source ~/.config/nvim/treesitter.vim
  source ~/.config/nvim/autopairs.vim
  source ~/.config/nvim/kommentary.vim
  source ~/.config/nvim/filetree.vim
  source ~/.config/nvim/telescope.vim
  source ~/.config/nvim/lualine.vim
  source ~/.config/nvim/blankline.vim
  source ~/.config/nvim/toggleterm.vim
endif
