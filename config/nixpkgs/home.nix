{ config, pkgs, ... }:

{
  home.username = "enoch";
  home.homeDirectory = "/home/enoch";

  home.packages = with pkgs; [
    fzf
    fd
    ripgrep
    bat
    tealdeer
    hyperfine
    delta
    tmux
  ];

  home.stateVersion = "22.05";

  programs.home-manager.enable = true;
}
