call plug#begin('~/.config/plugged')
Plug 'rakr/vim-one'
Plug 'rafamadriz/neon'
Plug 'projekt0n/github-nvim-theme'
Plug 'folke/tokyonight.nvim'

Plug 'editorconfig/editorconfig-vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install', 'for': 'markdown' }
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-surround'
" yarn pnp
Plug 'lbrayner/vim-rzip', { 'for': [ 'javascript', 'typescript', 'javascriptreact', 'typescriptreact' ]}

if has('nvim')
  " lsp
  Plug 'neovim/nvim-lspconfig'
  Plug 'williamboman/nvim-lsp-installer', { 'commit': '5d4195df48b7639aa1dbcf3e7d67fa9306ad0655' }
  Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'
  " formatting
  Plug 'mhartington/formatter.nvim', { 'do': 'npm install -g @fsouza/prettierd' }
  " completion
  Plug 'hrsh7th/cmp-nvim-lsp'
  Plug 'hrsh7th/cmp-buffer'
  Plug 'hrsh7th/cmp-path'
  Plug 'hrsh7th/cmp-cmdline'
  Plug 'hrsh7th/nvim-cmp'
  Plug 'L3MON4D3/LuaSnip'
  Plug 'saadparwaiz1/cmp_luasnip'
  " telescope
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
  " tree-sitter
  Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
  Plug 'windwp/nvim-ts-autotag'
  Plug 'windwp/nvim-autopairs'
  Plug 'nvim-treesitter/playground', { 'on': 'TSPlaygroundToggle' }
  " comment
  Plug 'JoosepAlviste/nvim-ts-context-commentstring'
  Plug 'b3nj5m1n/kommentary'
  " file tree
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'kyazdani42/nvim-tree.lua'
  " util
  Plug 'lewis6991/gitsigns.nvim'
  Plug 'akinsho/toggleterm.nvim'
  Plug 'hoob3rt/lualine.nvim'
  Plug 'lukas-reineke/indent-blankline.nvim'
  Plug 'goolord/alpha-nvim'
endif
call plug#end()

source ~/.config/nvim/settings.vim
source ~/.config/nvim/theme.vim
source ~/.config/nvim/markdown-preview.vim
source ~/.config/nvim/rzip.vim
if has('nvim')
  lua require('enoch.cmp')
  lua require('enoch.lsp')
  lua require('enoch.filetree')
  lua require('enoch.gitsigns')
  lua require('enoch.kommentary')
  lua require('enoch.lualine')
  lua require('enoch.blankline')
  lua require('enoch.autopairs')
  lua require('enoch.toggleterm')
  lua require('enoch.telescope')
  lua require('enoch.treesitter')
  lua require('enoch.alpha')

  source ~/.config/nvim/format.vim
endif
