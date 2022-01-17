#!/bin/zsh
export NIX_PATH=$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels${NIX_PATH:+:$NIX_PATH}
export PATH="$(yarn global bin):$PATH"
export PATH="$HOME/.local/bin:$PATH"
export BAT_THEME="Dracula"
export GIT_PAGER='delta --dark -s -n'

# set editor to nvim
export VISUAL=nvim
export EDITOR="$VISUAL"
alias vi="nvim"
alias vim="nvim"
alias cdnvim="cd ~/.config/nvim"

export ZSH="$HOME/.sheldon/repos/github.com/ohmyzsh/ohmyzsh"
plugins=(git)
eval "$(sheldon source)"

# go to git root directory
cdg() { cd "$(git rev-parse --show-toplevel)/$1" }
_cdg_completion()
{
  COMPREPLY="$(ls $(git rev-parse --show-toplevel || echo "$HOME")/)" 
}
complete -F _cdg_completion cdg

bindkey -v
