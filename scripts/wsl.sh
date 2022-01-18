#!/bin/bash

function cmd_exists(){
  if command -v "$1" &> /dev/null
  then
    echo true
  else
    echo false
  fi
}

apps=(
  'fzf'
  'ripgrep'
  'tmux'
  'neovim'
  'zsh'
  'git'
  'nodejs'
  'fd-find'
  'bat'
  'wget'
)

for app in "${apps[@]}"
do
  sudo apt install "$app"
done

# neovim
if ! cmd_exists "nvim" &> /dev/null
then
  /bin/bash ./nvim_install.sh
fi

# local sym links for aliased programs
local_symlinks=(
  'batcat:bat'
  'fd-find:fd'
)

mkdir -p ~/.local/bin
for link in "${local_symlinks[@]}"
do
  source=${link%%:*}
  destination=${link#*:}
  ln -s "/usr/bin/$source" "~/.local/bin/$destination"
done

# sheldon
if ! cmd_exists "sheldon" &> /dev/null
then
  curl --proto '=https' -fLsS https://rossmacarthur.github.io/install/crate.sh \
    | bash -s -- --repo rossmacarthur/sheldon --to ~/.local/bin
fi

# delta
if ! cmd_exists "delta" &> /dev/null
then
  wget https://github.com/dandavison/delta/releases/download/0.11.3/git-delta_0.11.3_amd64.deb
  sudo apt install ./git-delta_0.11.3_amd64.deb
  rm git-delta_0.11.3_amd64.deb
fi

# node global packages
node_pkgs=(
  'yarn'
  'n'
)

for pkgs in "${node_pkgs[@]}"
do
  npm install -g "$pkgs"
done
