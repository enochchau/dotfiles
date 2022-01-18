#!/bin/bash

function cmd_exists(){
  if command -v "$1" &> /dev/null
  then
    echo true
  else
    echo false
  fi
}

# install homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# install apps
apps=(
  'git'
  'fzf'
  'fd'  
  'ripgrep' 
  'bat' 
  'git-delta' 
  'tmux' 
  'node'
  'sheldon'
  'docker'
)

for app in "${apps[@]}"
do
  brew install "$app"
done

# neovim
if ! cmd_exists "nvim" &> /dev/null
then
  /bin/bash ./nvim_install.sh
fi

# install casks
casks=(
  'alacritty'  
  'visual-studio-code'
  'google-chrome'
  'discord'
  'spotify'
  'slack'
  'qbittorrent'
  'rectangle'
  'scroll-reverser'
  'alt-tab'
)

for cask in "${casks[@]}"
do
  brew install --cask "$cask"
done

# # install npm global packages
node_packages=(
  'yarn'
  'n'
)

for pkg in "${node_packages[@]}"
do
  npm install -g "$pkg"
done
