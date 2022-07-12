call plug#begin('~/.config/plugged')
" editing
Plug 'tpope/vim-obsession'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-sleuth'
Plug 'editorconfig/editorconfig-vim'

" comments
Plug 'tpope/vim-commentary'
Plug 'danymat/neogen'

" themes
Plug 'navarasu/onedark.nvim'
Plug 'rafamadriz/neon'
Plug 'folke/tokyonight.nvim'
Plug 'EdenEast/nightfox.nvim'

" preview
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install', 'for': 'markdown' }
" yarn pnp
Plug 'lbrayner/vim-rzip', { 'for': [ 'typescript', 'javascript', 'typescriptreact', 'javascriptreact' ] }
Plug 'ec965/nvim-pnp-checker'

" lsp
Plug 'neovim/nvim-lspconfig'
Plug 'jose-elias-alvarez/null-ls.nvim'
Plug 'jose-elias-alvarez/nvim-lsp-ts-utils'
Plug 'ec965/nvim-format-select'
Plug 'williamboman/nvim-lsp-installer'
Plug 'j-hui/fidget.nvim'
Plug 'b0o/schemastore.nvim'

" completion
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'f3fora/cmp-spell'
" snippets
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

" fuzzy finder
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
Plug 'nvim-telescope/telescope-ui-select.nvim'

" tree sitter
Plug 'nvim-treesitter/nvim-treesitter', { 'do': ':TSUpdate' }
Plug 'windwp/nvim-autopairs'
Plug 'windwp/nvim-ts-autotag'
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
Plug 'goolord/alpha-nvim'
Plug 'lewis6991/impatient.nvim'
Plug 'akinsho/toggleterm.nvim'
Plug 'ggandor/leap.nvim'

" file tree
Plug 'kyazdani42/nvim-web-devicons'
Plug 'MunifTanjim/nui.nvim'
Plug 'nvim-neo-tree/neo-tree.nvim'

call plug#end()

lua require('impatient')

source ~/.config/nvim/rzip.vim

lua require('enoch')
