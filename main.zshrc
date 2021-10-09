#!/bin/zsh
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

plugins=(git npm yarn)

source $ZSH/oh-my-zsh.sh

# Starship prompt
eval "$(starship init zsh)"

# set editor to nvim
export VISUAL=nvim
export EDITOR="$VISUAL"
alias vi="nvim"
alias vim="nvim"

# go to git root directory
cdg() { cd "$(git rev-parse --show-toplevel)/$1" }
_cdg_completion()
{
  COMPREPLY += "$(ls $(git rev-parse --show-toplevel || echo "$HOME")/)" 
}

export PATH="$HOME/.local/bin:$PATH"
