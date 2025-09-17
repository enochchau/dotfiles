# Configuration specific to my MacBook

# go
export PATH="$HOME/go/bin:$PATH"
# add kubectl-gopass extension to path
export PATH="$HOME/Gatsby/kubectl-gopass:$PATH"

# android studio
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

alias cdgadved="cdgp ui-gen2/src/components/AdvancedEditor/"

dev_scripts_base=~/code/dev-scripts
if test -d $dev_scripts_base; then
    alias proj="source $dev_scripts_base/project $HOME/Gatsby $HOME/code $HOME/Gatsby/repo $HOME/Gatsby/code"
fi

gatsby_scripts_base=~/Gatsby/scripts
if test -d $gatsby_scripts_base; then
    fpath+=$gatsby_scripts_base/completions
    alias aws-sso="$gatsby_scripts_base/aws-sso"
    alias aws-login="$gatsby_scripts_base/aws-login"
fi

# opam configuration
# [[ ! -r /Users/enochchau/.opam/opam-init/init.zsh ]] || source /Users/enochchau/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

export PATH="/usr/local/opt/mongodb-community@5.0/bin:$PATH"

# fzf keybinds and completion - must be loaded after ohmyzsh vi-mode plugin
FZF_BASE=$(brew --prefix)/opt/fzf/shell
source $FZF_BASE/key-bindings.zsh
source $FZF_BASE/completion.zsh

