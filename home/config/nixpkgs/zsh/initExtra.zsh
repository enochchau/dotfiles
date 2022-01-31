bindkey '^I'   complete-word       # tab          | complete
bindkey '^[[Z' autosuggest-accept  # shift + tab  | autosuggest
export PATH="$(yarn global bin):$PATH"
export PATH="$HOME/.local/bin:$PATH"

# go to git root directory
cdg() { cd "$(git rev-parse --show-toplevel)/$1" }
_cdg_completion()
{
  COMPREPLY="$(ls $(git rev-parse --show-toplevel || echo "$HOME")/)" 
}
complete -F _cdg_completion cdg

if test -f $ZDOTDIR/machine.zshrc; then 
  source $ZDOTDIR/machine.zshrc
fi

# source p10k 
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
