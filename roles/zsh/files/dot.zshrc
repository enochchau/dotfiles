# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

bindkey '^I'   complete-word       # tab          | complete
bindkey '^[[Z' autosuggest-accept  # shift + tab  | autosuggest

export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export ZSH=$HOME/.config/zsh/oh-my-zsh
export ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=( 
  git 
  vi-mode
  docker
  docker-compose
  kubectl
  ripgrep
  fd
  zsh-syntax-highlighting
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh


alias cddot='cd ~/dotfiles'
alias cdnix='cd ~/.config/nixpkgs'
alias cdnvim='cd ~/.config/nvim'
alias gcol='git branch | fzf | sed '\''s/^.* //'\'' | xargs git checkout'
alias gitdel='~/code/dev-scripts/git-delete.sh'
alias wtb='~/code/dev-scripts/bootstrap-worktree.sh'
alias vi="nvim"
alias vim="nvim"

cdg() { cd "$(git rev-parse --show-toplevel)/$1" }
_cdg_completion()
{
  COMPREPLY="$(ls $(git rev-parse --show-toplevel || echo "$HOME")/)" 
}
complete -F _cdg_completion cdg

if test -f $ZDOTDIR/machine.zshrc; then 
  source $ZDOTDIR/machine.zshrc
fi


# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
