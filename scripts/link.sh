#!/bin/bash

uname=`uname`

function make_link() {
  local from=$1
  local to=$2

  if [ -L "$to" ]
  then
    # link exists
    echo "Link exists for: $to"
    return
  fi

  echo "Creating link for: $from $to"
  ln -s $from $to
}

mkdir -p ~/.config

make_link $PWD/home/config/alacritty ~/.config/alacritty
make_link $PWD/home/config/nixpkgs ~/.config/nixpkgs

if [ $uname = 'Linux' ]
then
  mkdir -p ~/.config/Code/User
  make_link $PWD/home/vscode-settings.json ~/.config/Code/User/settings.json
elif [ $uname = 'Darwin' ]
then
  make_link $PWD/home/hammerspoon ~/.hammerspoon

  mkdir -p $HOME/Library/'Application Support'/Code/User
  make_link $PWD/home/vscode-settings.json $HOME/Library/'Application Support'/Code/User/settings.json
fi
