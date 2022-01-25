{ config, pkgs, ... }:

let
  myNodePackages = import ./nodejs/default.nix { };
  user = import ./user.nix { };
in
{
  imports = [
    ./nvim/init.nix
  ];

  home.username = user.username;
  home.homeDirectory = user.homeDirectory;

  home.stateVersion = "22.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    nix
    sumneko-lua-language-server
    nodejs
    nodePackages.typescript-language-server
    nodePackages.vscode-langservers-extracted # includes ccls, eslint, html, jsonls
    nodePackages.bash-language-server
    nodePackages.vim-language-server
    nodePackages.typescript
    nodePackages.eslint
    nodePackages.eslint_d
    nodePackages.node2nix
    nodePackages.npm
    nodePackages.yarn
    myNodePackages."@fsouza/prettierd"
    stylua
    nixpkgs-fmt
    fd
    ripgrep
    bat
    fzf
    zsh-autosuggestions
    zsh-syntax-highlighting
    delta
    rnix-lsp
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

  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";
    enableCompletion = true;
    enableAutosuggestions = true;
    enableSyntaxHighlighting = true;
    defaultKeymap = "viins";
    envExtra = ''
      export EDITOR="nvim"
      export VISUAL=$EDITOR
      export XDG_CONFIG_HOME="$HOME/.config"
      export XDG_CACHE_HOME="$HOME/.cache"
      export XDG_DATA_HOME="$HOME/.local/share"
      export XDG_STATE_HOME="$HOME/.local/state"
      if [ -e ${user.homeDirectory}/.nix-profile/etc/profile.d/nix.sh ]; then . ${user.homeDirectory}/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
    '';
    shellAliases = {
      cdnvim = "cd ~/.config/nvim";
      cddot = "cd ~/dotfiles";
      cdnix = "cd ~/.config/nixpkgs";
      gcol = "git branch | fzf | sed 's/^.* //' | xargs git checkout";
      gitdel = "~/code/dev-scripts/git-delete.sh";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "vi-mode"
        "docker"
        "docker-compose"
        "kubectl"
        "ripgrep"
        "fd"
      ];
    };
    plugins = [
      {
        name = "powerlevel10k";
        file = "powerlevel10k.zsh-theme";
        src = pkgs.fetchFromGitHub {
          owner = "romkatv";
          repo = "powerlevel10k";
          rev = "v1.16.0";
          sha256 = "gSPCNLK733+9NWdalqUJ8nzkhoQxurXAYX9t4859j2s=";
        };
      }
    ];
    initExtraFirst = ''
      if [[ -r "$\{XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-$\{(%):-%n}.zsh" ]]; then
        source "$\{XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-$\{(%):-%n}.zsh"
      fi
    '';
    initExtra = ''
      bindkey '^I'   complete-word       # tab          | complete
      bindkey '^[[Z' autosuggest-accept  # shift + tab  | autosuggest
      export PATH="$(yarn global bin):$PATH"
      export PATH="$HOME/.local/bin:$PATH"
      export BAT_THEME="Dracula"

      # go to git root directory
      cdg() { cd "$(git rev-parse --show-toplevel)/$1" }
      _cdg_completion()
      {
        COMPREPLY="$(ls $(git rev-parse --show-toplevel || echo "$HOME")/)" 
      }
      complete -F _cdg_completion cdg

      # source p10k 
      [[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
    '';
  };

  programs.ssh = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userName = user.gitUsername;
    userEmail = user.gitEmail;
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
