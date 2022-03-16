call plug#begin('~/.config/plugged')
" editing
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-surround'
Plug 'editorconfig/editorconfig-vim'
Plug 'b3nj5m1n/kommentary'

" themes
Plug 'morhetz/gruvbox'
Plug 'rakr/vim-one'
Plug 'rafamadriz/neon'
Plug 'projekt0n/github-nvim-theme'
Plug 'folke/tokyonight.nvim'

" preview
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install', 'for': 'markdown' }
" yarn pnp
Plug 'lbrayner/vim-rzip'
Plug 'ec965/nvim-pnp-checker'

" lsp
Plug 'neovim/nvim-lspconfig'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'
Plug 'ec965/nvim-format-select'
Plug 'williamboman/nvim-lsp-installer'

" completion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'f3fora/cmp-spell'
Plug 'ray-x/cmp-treesitter'
" snippets
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

" fuzzy finder
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }

" tree sitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'windwp/nvim-autopairs'
Plug 'windwp/nvim-ts-autotag'
Plug 'nvim-treesitter/playground'
Plug 'JoosepAlviste/nvim-ts-context-commentstring'

" additional language support
Plug 'pantharshit00/vim-prisma'
Plug 'hashivim/vim-terraform'
Plug 'ziglang/zig.vim'
Plug 'pearofducks/ansible-vim'

" status line
Plug 'nvim-lualine/lualine.nvim'

" qol
Plug 'lukas-reineke/indent-blankline.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'mhinz/vim-startify'
Plug 'akinsho/toggleterm.nvim'

" file tree
Plug 'kyazdani42/nvim-web-devicons'
Plug 'kyazdani42/nvim-tree.lua'
call plug#end()

source ~/.config/nvim/settings.vim
source ~/.config/nvim/rzip.vim
source ~/.config/nvim/theme.vim
source ~/.config/nvim/format.vim
lua require('enoch.blankline')
lua require('enoch.cmp')
lua require('enoch.filetree')
lua require('enoch.gitsigns')
lua require('enoch.kommentary')
lua require('enoch.lsp')
lua require('enoch.lualine')
lua require('enoch.telescope')
lua require('enoch.toggleterm')
lua require('enoch.treesitter')

nmap <silent> <C-M> :MarkdownPreviewToggle<CR>
lua require('nvim-autopairs').setup {}
