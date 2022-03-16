{ config, pkgs, ... }:

let
  myNodePackages = import ./nodejs/default.nix { };
  user = import ./user.nix { };
  zsh = import ./zsh/default.nix { pkgs = pkgs; user = user; };
  tmux = import ./tmux/default.nix { pkgs = pkgs; user = user; };
in
{

  home.username = user.username;
  home.homeDirectory = user.homeDirectory;

  home.stateVersion = "22.05";

  xdg.enable = true;

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # nix
    nix
    nixpkgs-fmt
    rnix-lsp
    # bash
    /* nodePackages.bash-language-server */
    # viml
    /* nodePackages.vim-language-server */
    # web dev lsps
    # includes ccls, eslint, html, jsonls
    /* nodePackages.vscode-langservers-extracted */
    # yml
    /* nodePackages.yaml-language-server */
    /* vale */
    # lua
    /* stylua
    luajit */
    /* sumneko-lua-language-server */
    # nodejs
    /* nodejs */
    /* nodePackages.eslint
    nodePackages.prettier
    nodePackages.node2nix
    nodePackages.npm
    nodePackages.yarn
    myNodePackages."@fsouza/prettierd"
    myNodePackages."@prisma/language-server" */
    # typescript
    /* nodePackages.typescript-language-server
    nodePackages.typescript */
    # cmd line util
    /* fdtypescript-language-server
    ripgrep
    fzf */
    # zsh
    /* zsh-autosuggestions
    zsh-syntax-highlighting */
    # tf
    /* terraform
    terraform-ls */
    # k8s
    /* kubectx
    kubectl
    kubernetes-helm */
    # golang
    /* gopls */
  ];

  programs.ssh.enable = false;

  programs.jq.enable = false;
  programs.zsh.enable = false;
  programs.tmux.enable = false;

  /* programs.bat = {
    enable = true;
    config = {
      theme = "Dracula";
      pager = "less -F";
    };
  };
 */
  programs.git = {
    enable = false;
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
      enable = false;
      options = {
        side-by-side = true;
        syntax-theme = "Dracula";
        navigate = true;
      };
    };
  };
}
