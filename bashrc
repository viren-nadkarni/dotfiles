#
# https://github.com/viren-nadkarni/dotfiles
#

# do nothing if not running interactively
[[ $- != *i* ]] && return

# do not put duplicate lines or lines starting with space in the history
# also erase prior duplicates
HISTCONTROL=ignoreboth:erasedups

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=5120
HISTFILESIZE=5120

# check the window size after each command and, if necessary, update the values of LINES and COLUMNS
shopt -s checkwinsize
# correct minor errors in the speling of a directory name in a cd command
shopt -s cdspell
# append history instead of overwriting
shopt -s histappend
#shopt -s autocd

# make less more friendly for non-text input files
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# append history to make it searchable across parallel sessions
export PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

export EDITOR="vim"
export TERM="xterm-256color"

# bash completion
[ -r /etc/bash_completion ] && source /etc/bash_completion

if [ "$(uname)" == "Darwin" ]; then
    export BASH_COMPLETION_COMPAT_DIR="/usr/local/etc/bash_completion.d"
    [[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && source "/usr/local/etc/profile.d/bash_completion.sh"

    export PATH="/usr/local/opt/coreutils/libexec/gnubin:$PATH"
    export PATH="/usr/local/opt/make/libexec/gnubin:$PATH"
    export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"
fi

command -v aws_completer >/dev/null 2>&1 && complete -C aws_completer aws
command -v terraform >/dev/null 2>&1 && complete -C terraform terraform

# python virtualenv
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/devel
export VIRTUALENVWRAPPER_PYTHON=$(which python3)
export VIRTUAL_ENV_DISABLE_PROMPT=1
[ -r /usr/share/virtualenvwrapper/virtualenvwrapper.sh ] && source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
[ -r /usr/local/bin/virtualenvwrapper.sh ] && source /usr/local/bin/virtualenvwrapper.sh
[ -r $HOME/.local/bin/virtualenvwrapper.sh ] && source $HOME/.local/bin/virtualenvwrapper.sh

# custom functions
[ -r ~/.bash_function ] && source ~/.bash_function

# custom aliases
[ -r ~/.bash_alias ] && source ~/.bash_alias

# fortune
#[ -x /usr/games/fortune ] && (echo; fortune zippy; echo)

# fzf keybindings
[ -r /usr/share/doc/fzf/examples/key-bindings.bash ] && source /usr/share/doc/fzf/examples/key-bindings.bash

# custom shell prompt
eval "$(starship init bash)"

# secrets
# DO NOT PLACE SECRETS IN THIS FILE!
[ -r ~/.secrets ] && source ~/.secrets
