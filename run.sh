#!/bin/bash

set -euo pipefail

## Usage:
##      ./run.sh <command>
## Commands:
##      install     Back up current dotfiles and install custom
##      restore     Remove custom dotfiles and restore original
## Options:
##      -h          Show this message

CWD=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

SUDO=''
if [ "$(id -u)" -ne 0 ]; then
    SUDO='sudo'
fi

DOTFILE_MAP=(
    "starship.toml:~/.config/starship.toml"
    "bash_alias:~/.bash_alias"
    "bash_function:~/.bash_function"
    "bashrc:~/.bashrc"
    "curlrc:~/.curlrc"
    "gdbinit:~/.gdbinit"
    "gitconfig:~/.gitconfig"
    "gitignore_global:~/.gitignore_global"
    "ideavimrc:~/.ideavimrc"
    "plug.vim:~/.vim/autoload/plug.vim"
    "tmux.conf:~/.tmux.conf"
    "vimrc:~/.vimrc"
    "wgetrc:~/.wgetrc"
    "AGENTS.md:~/.config/opencode/AGENTS.md"
    "tui.json:~/.config/opencode/tui.json"
)

function print_help {
    sed -rn 's/^## ?//;T;p' "$0"
}

function backup_dotfiles {
    for entry in "${DOTFILE_MAP[@]}"; do
        file_src="$CWD/${entry%%:*}"
        file_dest="${entry#*:}"
        file_dest="${file_dest/#\~/$HOME}"

        # Skip if already a symlink pointing into this repo
        if [ -L "$file_dest" ] && [ "$(readlink "$file_dest")" = "$file_src" ]; then
            continue
        fi

        if [ -e "$file_dest" ] || [ -L "$file_dest" ]; then
            file_backup="$(dirname "$file_dest")/$(basename "$file_dest").backup"
            mv "$file_dest" "$file_backup"
            echo "Backed up $file_dest to $file_backup"
        fi
    done
}

function install_dotfiles {
    for entry in "${DOTFILE_MAP[@]}"; do
        file_src="$CWD/${entry%%:*}"
        file_dest="${entry#*:}"
        file_dest="${file_dest/#\~/$HOME}"
        mkdir -p "$(dirname "$file_dest")"
        ln -sf "$file_src" "$file_dest"
        echo "Linked $file_src to $file_dest"
    done
}

function restore_dotfiles {
    for entry in "${DOTFILE_MAP[@]}"; do
        file_src="$CWD/${entry%%:*}"
        file_dest="${entry#*:}"
        file_dest="${file_dest/#\~/$HOME}"
        file_backup="$(dirname "$file_dest")/$(basename "$file_dest").backup"

        if [ -L "$file_dest" ] && [ "$(readlink "$file_dest")" = "$file_src" ]; then
            rm "$file_dest"
            echo "Removed symlink $file_dest"
        fi

        if [ -e "$file_backup" ]; then
            mv "$file_backup" "$file_dest"
            echo "Restored $file_backup to $file_dest"
        fi
    done
}

function install_vim_plugins {
    vim +PlugInstall +qall
}

function install_packages {
    if [ "$(uname)" == "Darwin" ]; then
        brew update
        brew install bat fd fzf ripgrep colordiff gawk gnu-sed gnu-getopt \
            grep findutils coreutils parallel wdiff \
            git git-extras git-delta git-lfs

    elif [ "$(uname)" == "Linux" ]; then
        # Assume Ubuntu
        $SUDO apt update
        $SUDO apt install -y \
            libssl-dev vim \
            bat fd-find fzf ripgrep colordiff wdiff pass pass-extension-otp \
            rustup build-essential autoconf automake make cmake apt-file pkg-config \
            net-tools fdisk \
            tmux tmuxinator pandoc texlive-latex-recommended \
            fonts-urw-base35 fonts-firacode fonts-powerline ttf-mscorefonts-installer \
            fonts-clear-sans fonts-montserrat fonts-open-sans

        rustup default stable

        cargo install --locked starship uv typst-cli

        echo
        echo "Install manually"
        echo "git-delta https://github.com/dandavison/delta"
        echo

    else
        echo "Unknown OS: $(uname)"
    fi
}

function post_steps {
    touch ~/.secrets
    chmod 0600 ~/.secrets
}

case "${1:-}" in
    install )
        backup_dotfiles
        install_dotfiles
        install_packages
        install_vim_plugins
        post_steps
        ;;
    restore )
        restore_dotfiles
        ;;
    -h )
        print_help
        exit 0
        ;;
    * )
        print_help
        exit 1
        ;;
esac
