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
  'docker'
  'watch'
)

for app in "${apps[@]}"
do
  brew install "$app"
done

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
