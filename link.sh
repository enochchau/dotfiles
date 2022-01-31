#!/bin/bash

uname=`uname`

mkdir -p ~/.config

ln -s ./home/config/alacritty ~/.config/alacritty
ln -s ./home/config/nixpkgs ~/.config/nixpkgs

if [ $uname = 'Linux' ]
then
  ln -s home/vscode-settings.json ~/.config/Code/User/settings.json
elif [ $uname = 'Darwin' ]
then
  ln -s home/vscode-settings.json ~/Library/Application Support/Code/User/settings.json
fi

