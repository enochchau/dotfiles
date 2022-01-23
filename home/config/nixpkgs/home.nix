{ config, pkgs, ... }:

let myNodePackages = import ./nodejs/default.nix {};
in
{
  imports = [
    ./nvim/init.nix
    ./user.nix
  ];

  home.stateVersion = "22.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    zsh
    nodejs
    nodePackages.typescript-language-server # includes ccls, eslint, html, jsonls
    nodePackages.vscode-langservers-extracted
    nodePackages.typescript
    nodePackages.eslint
    nodePackages.eslint_d
    nodePackages.node2nix
    myNodePackages."@fsouza/prettierd"
    fd
    ripgrep
    bat
    fzf
  ];

  programs.tmux = {
    enable = true;
    escapeTime = 0;
    historyLimit = 10000;
    keyMode = "vi";
    prefix = "C-a";
    customPaneNavigationAndResize = true;
    resizeAmount = 5;
    extraConfig = ''
      set -g mouse on
      set -g default-terminal "screen-256color"
      # tell Tmux that outside terminal supports true color
      set -ga terminal-overrides ",xterm-256color*:Tc"

      set -g status-style fg='black',bg='blue'
      set -g status-right "%a %I:%M%p %d %b %Y"

      set -g pane-border-style "fg=default bg=default"
      set -g pane-active-border-style "fg=colour4 bg=default"
    '';
  };

  programs.git = {
    enable = true;
    extraConfig = {
      merge = {
        conflictstyle = "diff3";
      };
      diff = {
        colorMoved = "default";
      };
      init = {
        defaultBranch = "main";
      };
      pull = {
        rebase = true;
      };
      pager = {
        branch = false;
      };
      gpg = {
        program = "gpg";
      };
      credential = {
        helper = "store";
      };
    };
    delta = {
      enable = true;
      options = {
        side-by-side =  true;
        syntax-theme = "Dracula";
        navigate = true;
      };
    };
  };
}