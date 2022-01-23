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
}
