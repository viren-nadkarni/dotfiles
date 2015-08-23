#!/bin/bash
set -euo pipefail
IFS=$'\n\t'

dotfiles_path=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
files="$(ls $dotfiles_path)"

operation=${1:-}
if [[ -z "$operation" ]]; then
    cat <<EOF
Usage: $0 <operation>
Operations:
   inst install
   upd  update submodules
   rm   remove
EOF
    exit 1
fi

case $operation in
    "inst")
        cd $dotfiles_path

        git submodule update --init --recursive

        for file in $files; do
            if [ $file == "$(basename $0)" ]; then
                continue
            fi

            if [ -a ~/.$file ]; then
                if [ -a ~/.${file}.old ]; then
                    echo "Skipping backup for .${file} because .${file}.old exists"
                else
                    echo "Backing up .${file} -> .${file}.old"
                    mv ~/.${file} ~/.${file}.old
                fi
            fi

            cp -r ${dotfiles_path}/${file} ~/.${file}
        done
    ;;

    "upd")
        git submodule foreach git pull origin master
    ;;

    "rm")
        for file in $files; do
            if [ $file == "$(basename $0)" ]; then
                continue
            fi
            rm -r ~/.$file
            if [ -a ~/.${file}.old ]; then
                mv ~/.${file}.old ~/.${file}
                echo "Restored .${file}.old -> .${file}"
            fi
        done
    ;;
esac

