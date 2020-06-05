
# https://github.com/viren-nadkarni/dotfiles
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
export PROMPT_COMMAND="history -a; get_git_info; get_virtualenv_info; $PROMPT_COMMAND"
export EDITOR="vim"
export TERM="xterm-256color"

# virtualenv
export WORKON_HOME=$HOME/.virtualenvs
export PROJECT_HOME=$HOME/devel
export VIRTUALENVWRAPPER_PYTHON=$(which python3)
export VIRTUAL_ENV_DISABLE_PROMPT=1
[ -r /usr/share/virtualenvwrapper/virtualenvwrapper.sh ] && source /usr/share/virtualenvwrapper/virtualenvwrapper.sh
[ -r /usr/local/bin/virtualenvwrapper.sh ] && source /usr/local/bin/virtualenvwrapper.sh
[ -r $HOME/.local/bin/virtualenvwrapper.sh ] && source $HOME/.local/bin/virtualenvwrapper.sh

# bash completion
[ -r /etc/bash_completion ] && source /etc/bash_completion

# functions
[ -r ~/.bash_function ] && source ~/.bash_function

# aliases
[ -r ~/.bash_alias ] && source ~/.bash_alias

# fortune
#[ -x /usr/games/fortune ] && (echo; fortune zippy; echo)

