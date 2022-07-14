return require("packer").startup(function(use)
  use("wbthomason/packer.nvim")

  -- editing
  use("tpope/vim-obsession")
  use("tpope/vim-surround")
  use("tpope/vim-sleuth")
  use("editorconfig/editorconfig-vim")

  -- comments
  use("tpope/vim-commentary")
  use("danymat/neogen")

  -- themes
  use("navarasu/onedark.nvim")
  use("rafamadriz/neon")
  use("folke/tokyonight.nvim")
  use("EdenEast/nightfox.nvim")

  -- preview
  use({
    "iamcco/markdown-preview.nvim",
    ft = { "markdown" },
    run = "cd app && yarn install",
  })
  -- yarn pnp
  use({
    "lbrayner/vim-rzip",
    ft = { "javascript", "typescript", "typescriptreact", "javascriptreact" },
  })
  use("ec965/nvim-pnp-checker")

  -- lsp
  use({
    "neovim/nvim-lspconfig",
    requires = {
      "jose-elias-alvarez/null-ls.nvim",
      "jose-elias-alvarez/nvim-lsp-ts-utils",
      "ec965/nvim-format-select",
      "williamboman/nvim-lsp-installer",
      "j-hui/fidget.nvim",
      "b0o/schemastore.nvim",
    },
  })

  -- completion
  use({
    "hrsh7th/nvim-cmp",
    requies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "f3fora/cmp-spell",
      -- snippets
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
  })

  -- fuzzy finder
  use({
    "nvim-telescope/telescope.nvim",
    requires = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        run = "make",
      },
      "nvim-telescope/telescope-ui-select.nvim",
    },
  })

  -- tree sitter
  use({
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
    requires = {
      "windwp/nvim-autopairs",
      "windwp/nvim-ts-autotag",
      "JoosepAlviste/nvim-ts-context-commentstring",
    },
  })

  -- additional language support
  use("pantharshit00/vim-prisma")
  use("hashivim/vim-terraform")
  use("ziglang/zig.vim")
  use("pearofducks/ansible-vim")

  -- status line
  use("nvim-lualine/lualine.nvim")

  -- qol
  use("lukas-reineke/indent-blankline.nvim")
  use("lewis6991/gitsigns.nvim")
  use("goolord/alpha-nvim")
  use("lewis6991/impatient.nvim")
  use("akinsho/toggleterm.nvim")
  use("ggandor/leap.nvim")

  -- file tree
  use({
    "nvim-neo-tree/neo-tree.nvim",
    requires = {
      "kyazdani42/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
  })
end)
