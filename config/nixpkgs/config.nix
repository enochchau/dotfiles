{
  packageOverrides = pkgs: {
    devTools = pkgs.buildEnv {
      name = "dev-tools-0.0.1";
      paths = [
        fzf
        fd
        ripgrep
        bat
        tealdeer
        delta
        tmux
      ]
    }
  }
}
