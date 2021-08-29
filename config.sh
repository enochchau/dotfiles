#!/bin/bash

OS=$(uname)

# symlink .config files
[ ! -d "$HOME/.config" ] && mkdir $HOME/.config
ln -s $PWD/nvim $HOME/.config/nvim
# neovim plugged
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
# install neovim plugins
nvim +'PlugInstall --sync' +qa

if [[ "$OS" == "Darwin" ]]; then
    cp vscode-settings.json $HOME/Library/Application Support/Code/User/settings.json
fi

if [[ "$OS" == "Linux" ]]; then
    cp vscode-settings.json $HOME/.config/Code/User/settings.json
fi
