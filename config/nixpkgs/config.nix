{
  packageOverrides = pkgs: with pkgs; {
    myTerminal = pkgs.buildEnv {
      name = "my-terminal";
      paths = [
        tmux
        fd
        bat
        ripgrep
        tealdeer
        hyperfine
        delta
        fzf
        nodejs
        (neovim.override {
          configure = {
            packages.myPlugins = with pkgs.vimPlugins; {
              start = [
                (nvim-treesitter.withPlugins (plugins: pkgs.tree-sitter.allGrammars))
              ];
            };
          };
        })
      ];
      /* pathsToLink = [ "/share" "/bin" ]; */
    };
    myGUIs = pkgs.buildEnv {
      name = "my-guis";
      paths = [
        alacritty 
        vscode
        google-chrome
        discord
        slack
        qbittorrent
        spotify
      ];
      pathsToLink = [ "/share" "/bin" "/Application" ];
    };
  };
}
