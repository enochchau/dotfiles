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
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-11.jdk/Contents/Home

dev_scripts_base=~/code/dev-scripts
alias proj="$dev_scripts_base/project.sh $HOME/Gatsby $HOME/code $HOME/Gatsby/repo"
alias rung="$dev_scripts_base/rungatsby"
alias killg="$dev_scripts_base/killgatsby"
alias cdgadved="cdgp ui-gen2/src/components/AdvancedEditor/"
alias python="python3"

export PULSAR_CPP_DIR="/usr/local/Cellar/libpulsar/3.4.0"

# opam configuration
# [[ ! -r /Users/enochchau/.opam/opam-init/init.zsh ]] || source /Users/enochchau/.opam/opam-init/init.zsh  > /dev/null 2> /dev/null

export PATH="/usr/local/opt/mongodb-community@5.0/bin:$PATH"
