#
# ~/.bashrc
#

# If not running interactively, don't do anything

stty -ixon

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"

[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls -lah'
alias wt='curl wttr.in/08-300?1AFQ'

PS1='[\u@\h \W]\$ '
#PS1='\[$(tput setaf 0)\]\[$(tput setab 6)\]\u@\h \W\$\[$(tput sgr0)\]\[$(tput setaf 6)\]\[$(tput sgr0)\]'
