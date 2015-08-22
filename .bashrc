# do nothing if not running interactively
[[ $- != *i* ]] && return

# don't put duplicate lines or lines starting with space in the history.
HISTCONTROL=ignoreboth

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1024
HISTFILESIZE=2048

# check the window size after each command and, if necessary, update the values of LINES and COLUMNS
shopt -s checkwinsize
# correct minor errors in the speling of a directory name in a cd command
shopt -s cdspell
# append history instead of overwriting
shopt -s histappend
shopt -s autocd

# make less more friendly for non-text input files
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        color_prompt=yes
    else
        color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1="\[\e[1;33m\]\u@\h\[\e[0m\] \[\e[1;31m\]\w\[\e[0m\] \$ "
else
    PS1="\u@\h \w \$ "
fi

unset color_prompt force_color_prompt

export EDITOR="vim"
export TERM="xterm-256color"

# bash-completion
[ -r /etc/bash_completion ] && . /etc/bash_completion

# functions
[ -r ~/.bash_functions ] && . ~/.bash_functions

# aliases
[ -r ~/.bash_aliases ] && ~/.bash_aliases

# fortune
#[ -x /usr/games/fortune ] && (echo; fortune; echo)
