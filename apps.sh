#!/bin/bash

OS=$(uname) # Linux or Darwin (MacOS)

# mac apps
if [[ "$OS" == "Darwin" ]]; then
    # homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew install --cask iterm2
    brew install neovim
    brew install --cask google-chrome
    brew install --cask visual-studio-code
    brew install --cask figma
    brew install --cask docker
    brew install --cask karabiner-elements
    brew install --cask spotify
    brew install --cask rectangle
    brew install --cask slack
    brew install --cask notion
fi

# linux apps
if [[ "$OS" == "Linux" ]]; then
    sudo apt update
    sudo apt upgrade -y

    # docker
     curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
    echo \
      "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
      $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # vscode
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
    sudo apt install apt-transport-https

    # spotify
    curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add - 
    echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list

    sudo apt update
    sudo apt install neovim
    sudo apt install docker-ce docker-ce-cli containerd.io
    sudo apt install code
    sudo apt install spotify-client
fi

# symlink .config files
[ ! -d "$HOME/.config" ] && mkdir $HOME/.config
ln -s $PWD/nvim $HOME/.config/nvim
# neovim plugged
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
