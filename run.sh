#!/bin/bash
set -euo pipefail
CWD=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

## run.sh
## Usage:
##      ./run.sh <command>
## Commands:
##      install     Back up current dotfiles and install custom
##      restore     Remove custom dotfiles and restore original
## Options:
##      -h          Show this message

dotfile_map=(
    "starship.toml:~/.config/starship.toml"
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
    "AGENTS.md:~/.config/opencode/AGENTS.md"
    "tui.json:~/.config/opencode/tui.json"
)

function print_help {
    sed -rn 's/^## ?//;T;p' "$0"
}

function backup_dotfiles {
    for entry in "${dotfile_map[@]}"; do
        file_src="$CWD/${entry%%:*}"
        file_dest="${entry#*:}"
        file_dest="${file_dest/#\~/$HOME}"

        # Skip if already a symlink pointing into this repo
        if [ -L "$file_dest" ] && [ "$(readlink "$file_dest")" = "$file_src" ]; then
            continue
        fi

        if [ -e "$file_dest" ] || [ -L "$file_dest" ]; then
            file_backup="$(dirname "$file_dest")/.$(basename "$file_dest").backup"
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
        mkdir -p "$(dirname "$file_dest")"
        ln -sf "$file_src" "$file_dest"
        echo "Linked $file_src to $file_dest"
    done
}

function restore_dotfiles {
    for entry in "${dotfile_map[@]}"; do
        file_src="$CWD/${entry%%:*}"
        file_dest="${entry#*:}"
        file_dest="${file_dest/#\~/$HOME}"
        file_backup="$(dirname "$file_dest")/.$(basename "$file_dest").backup"

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
        echo "Unknown OS: $(uname)"
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
            echo "Invalid choice"
            exit 1
    esac
}

case "${1:-}" in
    install )
        backup_dotfiles
        install_dotfiles
        prompt_choice
        install_packages
        install_vim_plugins
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
