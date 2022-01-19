#!/bin/zsh
export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels${NIX_PATH:+:$NIX_PATH}
export PATH="$(yarn global bin):$PATH"
export PATH="$HOME/.local/bin:$PATH"
export BAT_THEME="Dracula"

# set editor to nvim
export VISUAL=nvim
export EDITOR="$VISUAL"

# setup XDG
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

alias vi="nvim"
alias vim="nvim"
alias cdnvim="cd ~/.config/nvim"

export ZSH="$XDG_DATA_HOME/sheldon/repos/github.com/ohmyzsh/ohmyzsh"
plugins=(git)
eval "$(sheldon source)"

# go to git root directory
cdg() { cd "$(git rev-parse --show-toplevel)/$1" }
_cdg_completion()
{
  COMPREPLY="$(ls $(git rev-parse --show-toplevel || echo "$HOME")/)" 
}
complete -F _cdg_completion cdg

alias gcol="git branch | fzf | sed 's/^.* //' | xargs git checkout"

bindkey -v
