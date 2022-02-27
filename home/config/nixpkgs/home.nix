{ config, pkgs, ... }:

let
  myNodePackages = import ./nodejs/default.nix { };
  user = import ./user.nix { };
  zsh = import ./zsh/default.nix { pkgs = pkgs; user = user; };
  neovim = import ./nvim/default.nix { pkgs = pkgs; };
in
{

  home.username = user.username;
  home.homeDirectory = user.homeDirectory;

  home.stateVersion = "22.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # nix
    nix
    nixpkgs-fmt
    rnix-lsp
    # bash
    nodePackages.bash-language-server
    # viml
    nodePackages.vim-language-server
    # web dev lsps
    # includes ccls, eslint, html, jsonls
    nodePackages.vscode-langservers-extracted
    # yml
    nodePackages.yaml-language-server
    vale
    # lua
    stylua
    luajit
    sumneko-lua-language-server
    # nodejs
    nodejs
    nodePackages.eslint
    nodePackages.prettier
    nodePackages.node2nix
    nodePackages.npm
    nodePackages.yarn
    myNodePackages."@fsouza/prettierd"
    myNodePackages."@prisma/language-server"
    # typescript
    nodePackages.typescript-language-server
    nodePackages.typescript
    # cmd line util
    fd
    ripgrep
    fzf
    # zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
    # tf
    terraform
    terraform-ls
    # zig
    zig
    zls
  ];

  xdg.enable = true;
  programs.ssh.enable = true;
  programs.jq.enable = true;
  programs.zsh = zsh;
  programs.neovim = neovim;

  programs.bat = {
    enable = true;
    config = {
      theme = "Dracula";
      pager = "less -F";
    };
  };

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
    userName = user.gitUsername;
    userEmail = user.gitEmail;
    extraConfig = {
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
        side-by-side = true;
        syntax-theme = "Dracula";
        navigate = true;
      };
    };
  };
}
