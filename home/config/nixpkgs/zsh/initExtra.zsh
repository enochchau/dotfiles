bindkey '^I'   complete-word       # tab          | complete
bindkey '^[[Z' autosuggest-accept  # shift + tab  | autosuggest
export PATH="$(yarn global bin):$PATH"
export PATH="$HOME/.local/bin:$PATH"

if test -f $ZDOTDIR/machine.zshrc; then 
  source $ZDOTDIR/machine.zshrc
fi

# source p10k 
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh
