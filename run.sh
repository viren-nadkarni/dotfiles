#!/bin/bash
set -euo pipefail
CWD=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

## run.sh -- Install dotfiles
## Usage:
##      ./run.sh <option>
## Options:
##      -h      Show this message

dotfile_map=(
    "config:~/.config"
    "bash_alias:~/.bash_alias"
    "bash_function:~/.bash_function"
    "bashrc:~/.bashrc"
    "curlrc:~/.curlrc"
    "gdbinit:~/.gdbinit"
    "gitconfig:~/.gitconfig"
    "gitignore_global:~/.gitignore_global"
    "ideavimrc:~/.ideavimrc"
    "tmux.conf:~/.tmux.conf"
    "vim:~/.vim"
    "vimrc:~/.vimrc"
    "wgetrc:~/.wgetrc"
)

function print_help {
    sed -rn 's/^## ?//;T;p' "$0"
}

function backup_dotfiles {
    backup_dir=~/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)
    mkdir "$backup_dir"

    for entry in "${dotfile_map[@]}"; do
        file_dest="${entry#*:}"
        file_dest="${file_dest/#\~/$HOME}"
        if [ -a "$file_dest" ]; then
            file_backup="$backup_dir/$(basename "$file_dest")"
            mv "$file_dest" "$file_backup"
            echo "Backed up $file_dest to $file_backup"
        fi
    done
}

function install_dotfiles {
    for entry in "${dotfile_map[@]}"; do
        file_src="$CWD/${entry%%:*}"
        file_dest="${entry#*:}"
        file_dest="${file_dest/#\~/$HOME}"
        cp -r "$file_src" "$file_dest"
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
    if [ "$(uname)" == "Darwin" ]; then
        brew update
        brew install bat fd fzf ripgrep colordiff gawk gnu-sed gnu-getopt \
            git git-extras coreutils parallel wdiff git-delta git-lfs

    elif [ "$(uname)" == "Linux" ]; then
        # Assume Ubuntu
        sudo apt update
        sudo apt install -y bat fd-find fzf ripgrep colordiff wdiff pass pass-extension-otp \  # CLI tools
            rustup build-essential autoconf automake make cmake apt-file \  # build tools
            net-tools fdisk \  # sys tools
            tmux tmuxinator pandoc texlive-latex-recommended \  # stuff
            fonts-urw-base35 fonts-firacode fonts-powerline ttf-mscorefonts-installer \ # fonts
            fonts-clear-sans fonts-montserrat fonts-open-sans

        rustup default stable
        cargo install starship uv typst-cli --locked

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

    append_once() {
        local snippet_file=$1
        grep -qF "$(cat "$snippet_file")" ~/.bashrc || cat "$snippet_file" >> ~/.bashrc
    }

    case $REPLY in
        1 )
            append_once "${CWD}/_prompt_old"
            ;;
        2 )
            append_once "${CWD}/_prompt_starship"
            ;;
        * )
            echo "WTF, wrong choice"
            exit 1
    esac
}


if [[ ${1:-} == "-h" ]]; then
    print_help
    exit 0
fi

if [[ $# == 0 ]]; then
    print_help
    exit 1
fi

backup_dotfiles

install_dotfiles

prompt_choice

post_steps

bye
