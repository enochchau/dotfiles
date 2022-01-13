#!/bin/zsh
#
OS=`uname`
if [[ "$OS" == 'Linux' ]]; then
  curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh \
      | bash -s -- --repo rossmacarthur/sheldon --to ~/.local/bin
elif [[ "$OS" == 'Darwin' ]]; then
  brew install sheldon
fi
