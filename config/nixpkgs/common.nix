{ pkgs, ... }:
{
  targets.genericLinux.enable = true;
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
  programs.tmux = {
    enable = true;
    shortcut = "a";
    keyMode = "vi";
    historyLimit = 10000;
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
}
