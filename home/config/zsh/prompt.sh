#!/bin/zsh

# custom prompt
setopt promptsubst
autoload -U colors; colors
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' stagedstr '%F{green}+' 
zstyle ':vcs_info:*' unstagedstr '%F{red}!' 
zstyle ':vcs_info:*' check-for-changes true 
zstyle ':vcs_info:git*' actionformats '%F{blue}%b%u%c%m%F{red}%a '
zstyle ':vcs_info:git*' formats '%F{blue}%b%u%c%m '

# style vi mode
vim_ins_mode="%F{yellow}[INSERT]"
vim_cmd_mode="%F{magenta}[NORMAL]"
vim_mode=$vim_ins_mode

function zle-keymap-select {
  vim_mode="${${KEYMAP/vicmd/${vim_cmd_mode}}/(main|viins)/${vim_ins_mode}}"
  zle reset-prompt
}
zle -N zle-keymap-select

function zle-line-finish {
  vim_mode=$vim_ins_mode
}
zle -N zle-line-finish

# Fix a bug when you C-c in CMD mode and you'd be prompted with CMD mode indicator, while in fact you would be in INS mode
# Fixed by catching SIGINT (C-c), set vim_mode to INS and then repropagate the SIGINT, so if anything else depends on it, we will not break it
function TRAPINT() {
  vim_mode=$vim_ins_mode
  return $(( 128 + $1 ))
} 


PROMPT='%F{yellow}%5~ ${vcs_info_msg_0_}%F{cyan}%(!.#.$)%F{white} '
RPROMPT='%F{cyan}%T ${vim_mode}%F'

# disable cursor blink
echo -e -n "\e[2 q"
