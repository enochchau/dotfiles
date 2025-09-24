# Configuration specific to my MacBook

# go
export PATH="$HOME/go/bin:$PATH"

# android studio
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/tools
export PATH=$PATH:$ANDROID_HOME/tools/bin
export PATH=$PATH:$ANDROID_HOME/platform-tools

dev_scripts_base=~/code/dev-scripts
if test -d $dev_scripts_base; then
    alias proj="source $dev_scripts_base/project $HOME/code"
fi

# fzf keybinds and completion - must be loaded after ohmyzsh vi-mode plugin
FZF_BASE=$(brew --prefix)/opt/fzf/shell
source $FZF_BASE/key-bindings.zsh
source $FZF_BASE/completion.zsh

