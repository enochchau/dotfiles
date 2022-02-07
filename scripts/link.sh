#!/bin/bash

uname=`uname`

mkdir -p ~/.config

ln -s $PWD/home/config/alacritty ~/.config/alacritty
ln -s $PWD/home/config/nixpkgs ~/.config/nixpkgs

if [ $uname = 'Linux' ]
then
  mkdir -p ~/.config/Code/User
  ln -s $PWD/home/vscode-settings.json ~/.config/Code/User/settings.json
elif [ $uname = 'Darwin' ]
then
  ln -s $PWD/home/hammerspoon ~/.hammerspoon

  mkdir -p "$HOME/Library/Application Support/Code/User"
  ln -s $PWD/home/vscode-settings.json '~/Library/Application Support/Code/User/settings.json'
fi
