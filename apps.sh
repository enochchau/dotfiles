!/bin/bash

OS=$(uname) # Linux or Darwin (MacOS)

# mac apps
if [[ "$OS" == "Darwin" ]]; then
  # homebrew
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  brew install --cask iterm2
  brew install neovim
  brew install --cask google-chrome
  brew install --cask visual-studio-code
  brew install --cask docker
  brew install --cask discord
  brew install --cask spotify
  brew install --cask karabiner-elements
  brew install --cask figma
  brew install --cask rectangle
  brew install --cask slack
  brew install --cask notion
  brew install --cask qbittorrent
  brew install fd ripgrep bat sd tealdeer
  brew install node
  brew install fzf
  brew install git-delta
fi

# linux apps
if [[ "$OS" == "Linux" ]]; then
  sudo apt update && sudo apt upgrade -y

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

    # qbittorrent
    sudo add-apt-repository ppa:qbittorrent-team/qbittorrent-stable
    # pinta
    sudo add-apt-repository ppa:pinta-maintainers/pinta-stable


    sudo apt update

    # discord
    wget -O ~/discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
    sudo apt install ~/discord.deb 
    rm ~/discord.deb

    # chrome
    wget -O ~/google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install ~/google-chrome.dev
    rm ~/google-chrome.deb

    sudo apt install neovim
    sudo apt install pinta
    sudo apt install docker-ce docker-ce-cli containerd.io
    sudo apt install code
    sudo apt install spotify-client
    sudo apt install qbittorrent
    sudo apt isntall dconf-editor
    sudo apt install gnome-tweaks
    sudo apt install fd-find bat ripgrep 
    mkdir -p ~/.local/bin
    ln -s /usr/bin/batcat ~/.local/bin/bat
    ln -s /usr/bin/fdfind ~/.local/bin/fd
    sudo apt install fzf
    sudo apt install nodejs
    # missing sd, tealdeer, and delta
fi

npm install -g yarn n

# neovim plugged
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  # install neovim plugins
  nvim +'PlugInstall --sync' +qa
