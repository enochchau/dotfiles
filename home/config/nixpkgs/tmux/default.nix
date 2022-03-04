{ pkgs ? import <nixpkgs>, user, ... }:
{
  enable = true;
  escapeTime = 0;
  historyLimit = 10000;
  keyMode = "vi";
  prefix = "C-a";
  customPaneNavigationAndResize = true;
  resizeAmount = 5;
  extraConfig = builtins.readFile ./tmux.conf;
}
