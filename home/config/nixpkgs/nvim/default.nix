{ pkgs ? import <nixpkgs> }:
let
  myPlugins = pkgs.callPackage ./plugins.nix { };
  sourceVim = path: builtins.readFile path;
  sourceLua = path: "lua << EOF\n" + builtins.readFile path + "\nEOF";
in
{
  enable = true;
  viAlias = true;
  vimAlias = true;
  vimdiffAlias = true;
  plugins = with pkgs.vimPlugins; [
    {
      plugin = vim-obsession;
      # this stuff needs to be at the top of the init.vim
      config = ''
        ${sourceVim ./settings.vim}
        ${sourceVim ./theme.vim}
        ${sourceVim ./format.vim}
      '';
    }

    vim-surround
    # themes
    tokyonight-nvim
    neon
    myPlugins.github-nvim-theme
    vim-one
    nightfox-nvim
    papercolor-theme
    myPlugins.rose-pine
    gruvbox
    neovim-ayu
    myPlugins.solarized-nvim
    # vimscript utils
    editorconfig-vim
    {
      plugin = markdown-preview-nvim;
      config = "nmap <silent> <C-M> :MarkdownPreviewToggle<CR>";
    }
    { plugin = myPlugins.vim-rzip; config = sourceVim ./rzip.vim; }
    # completion
    cmp-buffer
    cmp-nvim-lsp
    cmp-path
    cmp-cmdline
    cmp-treesitter
    cmp-spell
    luasnip
    cmp_luasnip
    { plugin = nvim-cmp; config = sourceLua ./cmp.lua; }
    # lsp
    { plugin = nvim-lspconfig; config = sourceLua ./lsp.lua; }
    nvim-lsp-ts-utils
    { plugin = null-ls-nvim; config = sourceLua ./null-ls.lua; }
    # telescope
    plenary-nvim
    { plugin = telescope-nvim; config = sourceLua ./telescope.lua; }
    telescope-fzf-native-nvim
    # treesitter
    {
      plugin = nvim-treesitter;
      /* (nvim-treesitter.withPlugins (
        plugins: with plugins; [
        # missing tree-sitter-hcl
        tree-sitter-bash
        tree-sitter-comment
        tree-sitter-css
        tree-sitter-dockerfile
        tree-sitter-dot
        tree-sitter-graphql
        tree-sitter-html
        tree-sitter-javascript
        tree-sitter-jsdoc
        tree-sitter-json
        tree-sitter-julia
        tree-sitter-lua
        tree-sitter-nix
        tree-sitter-query
        tree-sitter-regex
        tree-sitter-scss
        tree-sitter-svelte
        tree-sitter-tsx
        tree-sitter-typescript
        tree-sitter-vim
        tree-sitter-yaml
        ]
        )); */
      config = sourceLua ./treesitter.lua;
    }
    { plugin = nvim-autopairs; config = "lua require('nvim-autopairs').setup {}"; }
    nvim-ts-autotag
    playground
    vim-prisma
    # comment
    nvim-ts-context-commentstring
    { plugin = kommentary; config = sourceLua ./kommentary.lua; }
    # other
    { plugin = lualine-nvim; config = sourceLua ./lualine.lua; }
    { plugin = indent-blankline-nvim; config = sourceLua ./blankline.lua; }
    { plugin = gitsigns-nvim; config = sourceLua ./gitsigns.lua; }
    { plugin = toggleterm-nvim; config = sourceLua ./toggleterm.lua; }
    vim-startify
    # file tree
    nvim-web-devicons
    { plugin = nvim-tree-lua; config = sourceLua ./filetree.lua; }
  ];
}
