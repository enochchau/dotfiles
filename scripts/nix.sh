#!/bin/bash

OS=`uname`
IS_WSL=`grep -qEi "microsoft|WSL" /proc/version &> /dev/null`

# install nix
if ! command -v nix-env &> /dev/null; then
  if $IS_WSL; then
    sh <(curl -L https://nixos.org/nix/install) --no-daemon
  elif [[ "$OS" == 'Linux' ]]; then
    sudo sh <(curl -L https://nixos.org/nix/install) --daemon
  elif [[ "$OS" == 'Darwin' ]]; then
    sh <(curl -L https://nixos.org/nix/install)
  fi
fi

nix-env -iA "nixpkgs.myPackages"
if $IS_WSL; then
  echo 'skipping GUI packages'
else
  nix-env -iA "nixpkgs.GUIs"
fi
