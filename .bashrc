#
# ~/.bashrc
#

# If not running interactively, don't do anything

stty -ixon

[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls -lah'

PS1='[\u\]@\h \W]\$ '
#PS1='\[$(tput setaf 0)\]\[$(tput setab 6)\]\u@\h \W\$\[$(tput sgr0)\]\[$(tput setaf 6)\]\[$(tput sgr0)\]'
