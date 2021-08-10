#!/bin/bash

# install zsh and oh-my-zsh
OS=$(uname) # Linux or Darwin (MacOS)
if [[ "$OS" == "Linux" ]]; then
    sudo apt install zsh
fi
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# power level 10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
# .zshrc
cp $PWD/main.zshrc $HOME/.zshrc
