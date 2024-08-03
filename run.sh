#!/bin/bash
set -euo pipefail
CWD=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

## run.sh -- Install dotfiles
## Usage:
##      ./run.sh <option>
## Options:
##      -h      Show this message

dotfiles="config bash_alias bash_function bashrc curlrc gdbinit gitconfig gitignore_global ideavimrc tmux.conf vim vimrc wgetrc"

function print_help {
    sed -rn 's/^## ?//;T;p' "$0"
}

function backup_dotfiles {
    backup_dir=~/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)
    mkdir $backup_dir

    for file in $dotfiles; do
        file_src=~/.${file}
        if [ -a $file_src ]; then
            file_dest=$backup_dir/.${file}
            mv $file_src $file_dest
            echo "Backed up $file_src to $file_dest"
        fi
    done
}

function install_dotfiles {
    for file in $dotfiles; do
        file_src=$CWD/$file
        file_dest=~/.$file
        cp -r $file_src $file_dest
        echo "Copied $file_src to $file_dest"
    done
}

function bye {
    echo
    echo "Complete plugin install in Vim with"
    echo "  :PlugInstall"
    echo
}

function post_steps {
    if [ $(uname) == "Darwin" ]; then
        brew update
        brew install bat exa fd fzf ripgrep colordiff gawk gnu-sed gnu-getopt \
            git git-extras coreutils parallel wdiff git-delta

    elif [ $(uname) == "Linux" ]; then
        # Assume Ubuntu
        sudo apt update
        sudo apt install -y bat fd-find fzf ripgrep colordiff wdiff fonts-powerline pass pass-extension-otp exa cargo build-essential cmake
        cargo install starship --locked

        echo
        echo "Install manually"
        echo "git-delta https://github.com/dandavison/delta"
        echo

    else
        echo "WTF, unknown OS"
    fi
}

function prompt_choice {
    echo
    echo "Select the shell prompt:"
    echo "[1] The old shell prompt"
    echo "[2] Starship"

    read -p "> " -n 1
    echo

    case $REPLY in
        1 )
            cat ${CWD}/_prompt_old >> ~/.bashrc
            ;;
        2 )
            cat ${CWD}/_prompt_starship >> ~/.bashrc
            ;;
        * )
            echo "WTF, wrong choice"
            exit 1
    esac
}


if [[ $# == 1 ]] || [[ ${1:-} == "-h" ]]; then
    print_help
    exit 1
fi

backup_dotfiles

install_dotfiles

prompt_choice

post_steps

bye
