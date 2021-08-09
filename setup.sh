#!/bin/bash

# install zsh and oh-my-zsh
OS=$(uname) # Linux or Darwin (MacOS)
if [[ "$OS" == "Linux" ]]; then
    sudo apt install zsh
fi
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# power level 10k
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# mac apps
if [[ "$OS" == "Darwin" ]]; then
    # homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew install --cask iterm2
    brew install neovim
fi

# install Linux apps
if [[ "$OS" == "Linux" ]]; then
    sudo apt install neovim
fi

# .zshrc
cp $PWD/.zshrc $HOME/.zshrc
# symlink .config files
ln -s $PWD/nvim $HOME/.config/nvim
