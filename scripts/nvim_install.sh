#!/bin/bash

OS=`uname`
if [[ "$OS" == "Darwin" ]]; then
  brew install neovim 
elif [[ "$OS" == "Linux" ]]; then
  sudo apt install neovim
fi

# neovim plugged
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

# install neovim plugins
nvim +'PlugInstall --sync' +qa
