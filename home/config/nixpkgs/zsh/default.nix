{ pkgs, user, ... }:
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
  initExtraFirst = builtins.readFile ./initFirst.zsh;
  initExtra = builtins.readFile ./initExtra.zsh;
}
