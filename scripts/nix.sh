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

nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager
nix-channel --update
home-manager switch
