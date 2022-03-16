{ pkgs ? import <nixpkgs>, user, ... }:
{
  enable = true;
  dotDir = ".config/zsh";
  enableCompletion = true;
  enableAutosuggestions = true;
  enableSyntaxHighlighting = true;
  defaultKeymap = "viins";
  envExtra = ''
    if [ -e ${user.homeDirectory}/.nix-profile/etc/profile.d/nix.sh ]; then . ${user.homeDirectory}/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
  '';
  sessionVariables = {
    EDITOR = "nvim -e";
    VISUAL = "nvim";
  };
  shellAliases = {
    cdnvim = "cd ~/.config/nixpkgs/nvim";
    cddot = "cd ~/dotfiles";
    cdnix = "cd ~/.config/nixpkgs";
    gcol = "git branch | fzf | sed 's/^.* //' | xargs git checkout";
    gitdel = "~/code/dev-scripts/git-delete.sh";
    wtb = "~/code/dev-scripts/bootstrap-worktree.sh";
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
    {
      name = "my-completions";
      src = ~/.config/nixpkgs/zsh/completions;
    }
    {
      name = "my-scripts";
      src = ~/.config/nixpkgs/zsh/scripts;
    }
  ];
  initExtraFirst = builtins.readFile ./initFirst.zsh;
  initExtra = builtins.readFile ./initExtra.zsh;
}
