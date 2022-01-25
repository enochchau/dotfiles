#!/bin/bash

# install nix depending on the OS
if grep -Ei "(microsoft|wsl)" /proc/version &> /dev/null; then
  sh <(curl -L https://nixos.org/nix/install) --no-daemon
elif [ $(uname) = 'Linux' ]; then
  sh <(curl -L https://nixos.org/nix/install) --daemon
elif [ $(uname) = 'Darwin' ]; then
  sh <(curl -L https://nixos.org/nix/install)
fi
