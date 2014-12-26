# do nothing if not running interactively
[[ $- != *i* ]] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

shopt -s checkwinsize # check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s cdspell # correct minor errors in the speling of a directory name in a cd command
shopt -s histappend # append history instead of overwriting
shopt -s autocd

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

export EDITOR="vim"
export TERM="xterm-256color"

force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    # We have color support; assume it's compliant with Ecma-48
    # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
    # a case would tend to support setf rather than setaf.)
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


# fortune
#[[ "$PS1" ]] && /usr/bin/fortune


# bash-completion
[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion
[ -r /etc/bash_completion ] && . /etc/bash_completion


[ -r ~/.aliases ] && . ~/.aliases
[ -r ~/.bash_aliases ] && ~/.bash_aliases
