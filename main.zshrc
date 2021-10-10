#!/bin/zsh
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"

fi
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git npm yarn)

source $ZSH/oh-my-zsh.sh

# source p10k config
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

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
complete -F _cdg_completion cdg

export PATH="$(yarn global bin):$PATH"
export PATH="$HOME/.local/bin:$PATH"
export BAT_THEME="GitHub"
export GIT_PAGER='delta --light -s -n'
