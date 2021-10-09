#!/bin/bash

OS=$(uname)

# zsh
if [[ "$OS" == "Linux" ]]; then
  sudo apt install zsh
fi

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
ln -s $PWD/main.zshrc $HOME/.main.zshrc
echo "#!/bin/zsh" > $HOME/.zshrc
echo 'source $HOME/.main.zshrc' >> $HOME/.zshrc
source $HOME/.zshrc
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k


# symlink .config files
mkdir -p $HOME/.config
ln -s $PWD/nvim $HOME/.config/nvim

if [[ "$OS" == "Darwin" ]]; then
  cp vscode-settings.json $HOME/Library/Application Support/Code/User/settings.json
fi

if [[ "$OS" == "Linux" ]]; then
  cp vscode-settings.json $HOME/.config/Code/User/settings.json
fi
