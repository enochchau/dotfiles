let
  pkgs = import <nixpkgs> { };
  myPlugins = pkgs.callPackage ./plugins.nix { };
  sourceVim = path: builtins.readFile path;
  sourceLua = path: "lua << EOF\n" + builtins.readFile path + "\nEOF";
in
{
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = with pkgs.vimPlugins; [
      {
        plugin = vim-obsession;
        # this stuff needs to be at the top of the init.vim
        config = sourceVim ./settings.vim + "\n" + sourceVim ./theme.vim + "\n" + sourceVim ./format.vim;
      }

      vim-surround
      # themes
      tokyonight-nvim
      neon
      myPlugins.github-nvim-theme
      vim-one
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
        plugin = (nvim-treesitter.withPlugins (
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
        ));
        config = sourceLua ./treesitter.lua;
      }
      { plugin = nvim-autopairs; config = "lua require('nvim-autopairs').setup {}"; }
      nvim-ts-autotag
      playground
      # comment
      nvim-ts-context-commentstring
      { plugin = kommentary; config = sourceLua ./kommentary.lua; }
      # other
      { plugin = lualine-nvim; config = sourceLua ./lualine.lua; }
      { plugin = indent-blankline-nvim; config = sourceLua ./blankline.lua; }
      { plugin = gitsigns-nvim; config = "lua require('gitsigns').setup()"; }
      { plugin = toggleterm-nvim; config = sourceLua ./toggleterm.lua; }
      vim-startify
      # file tree
      nvim-web-devicons
      { plugin = nvim-tree-lua; config = sourceLua ./filetree.lua; }
    ];
  };
}
