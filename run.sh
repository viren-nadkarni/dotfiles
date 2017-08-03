#!/bin/bash
set -xeuo pipefail
#IFS=$'\n\t'

dotfiles_path=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
files="bash_alias bash_function bashrc curlrc gdbinit gitconfig tmux.conf vim vimrc wgetrc"

function print_help {
    cat <<EOF
Usage: $0 <operation>
Operations:
   install
   uninstall
   update
EOF
}

operation=${1:-}
if [[ -z "$operation" ]]; then
    print_help
    exit 1
fi

case $operation in
    "install")
        sudo apt install -y colordiff fonts-powerline python3-pip wdiff
        sudo -H pip3 install powerline-status
        cat <<- EOT > ~/.ipython/profile_default/ipython_config.py
        c = get_config()
        c.InteractiveShellApp.extensions = [
            'powerline.bindings.ipython.post_0_11'
        ]
EOT

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
                    cat ${dotfiles_path}/bashrc >> ~/.bashrc
                    continue
                fi
            fi
            cp -r ${dotfiles_path}/${file} ~/.${file}
        done

    ;;

    "update")
        git submodule foreach git pull origin master
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

