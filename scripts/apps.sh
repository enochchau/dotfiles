!/bin/bash

OS=$(uname) # Linux or Darwin (MacOS)

# mac apps
if [[ "$OS" == "Darwin" ]]; then
  # homebrew
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # dev
  brew install --cask alacritty
  brew install --cask visual-studio-code # best debugger in town
  brew install --cask docker
  brew install tmux
  brew install node
  # apps
  brew install --cask google-chrome
  brew install --cask discord
  brew install --cask spotify
  brew install --cask slack
  brew install --cask qbittorrent
  # QOL
  brew install --cask rectangle
  brew install --cask scroll-reverser
  brew install --cask alt-tab
  # command line utils
  brew install fd ripgrep bat sd tealdeer hyperfine git-delta fzf
fi

# linux apps
if [[ "$OS" == "Linux" ]]; then
  sudo apt update && sudo apt upgrade -y

  # get PPAs
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

    # apps
    # discord
    wget -O ~/discord.deb "https://discordapp.com/api/download?platform=linux&format=deb"
    sudo apt install ~/discord.deb 
    rm ~/discord.deb
    # chrome
    wget -O ~/google-chrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt install ~/google-chrome.dev
    rm ~/google-chrome.deb
    sudo apt install pinta
    sudo apt install spotify-client
    sudo apt install qbittorrent

    # dev
    # missing alacritty
    sudo apt install docker-ce docker-ce-cli containerd.io
    sudo apt install tmux
    sudo apt install code
    sudo apt install nodejs
    # gnome
    sudo apt isntall dconf-editor
    sudo apt install gnome-tweaks
    # command line utils
    # missing sd, tealdeer, and delta
    sudo apt install fd-find bat ripgrep hyperfine fzf
    mkdir -p ~/.local/bin
    ln -s /usr/bin/batcat ~/.local/bin/bat
    ln -s /usr/bin/fdfind ~/.local/bin/fd
fi

npm install -g yarn n
