#!/bin/bash
set -xeuo pipefail
#IFS=$'\n\t'

dotfiles_path=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
files="bash_alias bash_function bashrc curlrc gdbinit gitconfig gitignore_global tmux.conf vim vimrc wgetrc"

function print_help {
    cat <<EOF
Usage: $0 <operation>
Operations:
   install
   uninstall
EOF
}

operation=${1:-}
if [[ -z "$operation" ]]; then
    print_help
    exit 1
fi

case $operation in
    "install")
        cd $dotfiles_path

        git submodule update --init --recursive

        for file in $files; do
            if [ -a ~/.${file} ]; then
                if [ -a ~/.${file}.old ]; then
                    echo "Skipping '.${file}' as '.${file}.old' exists"
                else
                    echo "Backed up '.${file}' to '.${file}.old'"
                    mv ~/.${file} ~/.${file}.old
                fi
            fi

            if [ ${file} == "bashrc" ]; then
                if grep "viren-nadkarni" ~/.bashrc 1> /dev/null; then
                    echo "Skipping '.bashrc' append"
                    continue
                else
                    cat ${dotfiles_path}/bashrc ${dotfiles_path}/_bash_prompt >> ~/.bashrc
                    continue
                fi
            fi
            cp -r ${dotfiles_path}/${file} ~/.${file}
        done

        echo
        echo "Complete plugin install in Vim with"
        echo "  :PlugInstall"
        echo
        echo "Install manually"
        echo "bat       https://github.com/sharkdp/bat"
        echo "          https://github.com/eth-p/bat-extras"
        echo "exa       https://github.com/ogham/exa"
        echo "ripgrep   https://github.com/BurntSushi/ripgrep"
        echo "fzf       https://github.com/junegunn/fzf"
        echo "fd        https://github.com/sharkdp/fd"
        echo
        echo "sudo apt install -y colordiff wdiff fonts-powerline"
        echo

    ;;

    "uninstall"|"remove")
        for file in $files; do
            rm -r ~/.${file}

            if [ -a ~/.${file}.old ]; then
                mv ~/.${file}.old ~/.${file}
                echo "Restored '.${file}'"
            fi
        done
    ;;

    *)
        print_help
        exit 1
    ;;
esac

