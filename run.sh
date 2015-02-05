#!/bin/bash

dotfiles="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
files=".aliases .bashrc .gitconfig .nanorc .vimrc .vim"

function usage {
    cat <<EOF
Usage: $0 <option>
  inst      install
  update    update vim bundles
  rm        uninstall
EOF
}

MODE="copy"
function inst_mode {
    echo "[1] Copy"
    echo " 2  Symlink"
    read -p ": " -n 1 -r
    echo
    [[ $REPLY =~ ^[2]$ ]] && MODE="symlink"
}

function self_destroy {
    read -p "Delete $dotfiles? [y/N] " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]] && rm -rf $dotfiles && exit 0
}

case $1 in
    "inst")
        inst_mode
        cd $dotfiles

        git submodule update --init --recursive

        if [ "$MODE" == "symlink" ]; then
            for file in $files; do
                if [ -L ~/$file ]; then
                    echo "Symlinks exist"
                    exit 1
                fi
            done
        fi

        for file in $files; do
            if [ -a ~/$file ]; then
                if [ -a ~/$file".old" ]; then
                    epoch=$(date +"%s")
                    echo "Renaming "$file" to "$file".old."$epoch
                    mv ~/$file ~/$file".old."$epoch
                else
                    echo "Renaming "$file" to "$file".old"
                    mv ~/$file ~/$file".old"
                fi
            fi

            if [ "$MODE" == "symlink" ]; then
                ln -s $dotfiles/$file ~/$file
            else
                cp -r $dotfiles/$file ~/$file
                self_destroy
            fi
        done
    ;;

    "update")
        git submodule foreach git pull origin master
    ;;

    "rm")
        for file in $files; do
            rm -r ~/$file
            if [ -a ~/$file".old" ]; then
                echo "Old $file restored"
                mv ~/$file".old" ~/$file
            fi
        done
        self_destroy
    ;;

    *)
        usage
        exit 1
    ;;
esac

