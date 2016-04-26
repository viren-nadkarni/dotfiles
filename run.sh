#!/bin/bash
set -xeuo pipefail
#IFS=$'\n\t'

dotfiles_path=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
files="bash_alias bash_function gitconfig tmux.conf vim vimrc"

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
                    echo ".${file} not backed up because .${file}.old exists"
                else
                    echo "Backed up .${file} -> .${file}.old"
                    mv ~/.${file} ~/.${file}.old
                fi
            fi

            cp -r ${dotfiles_path}/${file} ~/.${file}
        done

        grep "viren-nadkarni" ~/.bashrc 1> /dev/null || (cp ~/.bashrc ~/.bashrc.old; cat ${dotfiles_path}/_bashrc ${dotfiles_path}/_color_prompt >> ~/.bashrc)
    ;;

    "update")
        git submodule foreach git pull origin master
    ;;

    "uninstall"|"remove")
        files="${files} bashrc"
        for file in $files; do
            rm -r ~/.${file}

            if [ -a ~/.${file}.old ]; then
                mv ~/.${file}.old ~/.${file}
                echo "Restored .${file}.old -> .${file}"
            fi
        done
    ;;

    *)
        print_help
        exit 1
    ;;
esac

