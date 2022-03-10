{ pkgs, lib, ... }:

# emapty sha256
# use this and then copy in the expected sha256
# 0000000000000000000000000000000000000000000000000000
let
  githubPlugin = { repo, rev, sha256 ? "0000000000000000000000000000000000000000000000000000" }:
    let
      split = builtins.split "/" repo;
      owner = builtins.elemAt split 0;
      name = builtins.elemAt split 2;
    in
    pkgs.vimUtils.buildVimPluginFrom2Nix {
      name = name;
      src = pkgs.fetchFromGitHub {
        owner = owner;
        repo = name;
        rev = rev;
        sha256 = sha256;
      };
    };
in
{
  vim-rzip = githubPlugin {
    repo = "lbrayner/vim-rzip";
    rev = "b04384e6c79bcdc2ac6e3d42dd2d7730f8c02b0d";
    sha256 = "4mcoav4tyLS6KT5fTvarugoRdVDoe5/5lwU66mEXXTc=";
  };
  github-nvim-theme = githubPlugin {
    repo = "projekt0n/github-nvim-theme";
    rev = "1700dfe790985ce859868e16e13dcda0ec80cb3f";
    sha256 = "sha256-3Rp0oL+yhojQ6bIejS4IlPzyrxut7LcuobykonrpAEc=";
  };
  solarized-nvim = githubPlugin {
    repo = "shaunsingh/solarized.nvim";
    rev = "26dea71db242c64c220e7cd311d659c4f98e30aa";
    sha256 = "sha256-EMN4Ru6B9FBwvR33gON81LPjZk5X0sG5wamlSxZjNcU=";
  };
  rose-pine = githubPlugin {
    repo = "rose-pine/neovim";
    rev = "b6f26f45d920a246f075b888c24edfa744a1c551";
    sha256 = "sha256-4OJU+WMbn9sJe6z1DasQqzNK0oRjhkDzk+JWXBUD0xE=";
  };
  nvim-pnp-checker = githubPlugin {
    repo = "ec965/nvim-pnp-checker";
    rev = "e0411cc465eba8c9d37bd55e7b5fc991290424d7";
    sha256  = "sha256-VGpPiklTUDk5hnMIY2f8w86yIMJpL4E0SSD9Y12tKsM=";
  };
}
