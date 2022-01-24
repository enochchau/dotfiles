{ pkgs, ... }:

{
  vim-rzip = pkgs.vimUtils.buildVimPlugin {
    name = "vim-rzip";
    src = pkgs.fetchFromGitHub {
      owner = "lbrayner";
      repo = "vim-rzip";
      rev = "b04384e6c79bcdc2ac6e3d42dd2d7730f8c02b0d";
      sha256 = "4mcoav4tyLS6KT5fTvarugoRdVDoe5/5lwU66mEXXTc=";
    };
  };
  github-nvim-theme = pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "github-nvim-theme";
    src = pkgs.fetchFromGitHub {
      owner = "projekt0n";
      repo = "github-nvim-theme";
      rev = "1700dfe790985ce859868e16e13dcda0ec80cb3f";
      sha256 = "sha256-3Rp0oL+yhojQ6bIejS4IlPzyrxut7LcuobykonrpAEc=";
    };
  };
}
