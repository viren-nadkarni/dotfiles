#!/bin/bash

dotfiles="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
files=".aliases .bashrc .gitconfig .nanorc .vimrc .vim"

function usage {
    cat <<EOF
Usage: $0 <option>
  inst      install
  update    update vim bundles
  min       minimal install
  rm        uninstall
EOF
}

function destruct {
    read -p "Delete $dotfiles? [y|N] " -n 1 -r
    echo
    [[ $REPLY =~ ^[Yy]$ ]] && rm -rf $dotfiles && exit 0
}

case $1 in
    "inst")
        MODE="1"
        echo "[1] Symlinks"
        echo " 2  Copy"
        read -p ": " -n 1 -r
        echo
        [[ $REPLY =~ ^[2]$ ]] && MODE="2"

        cd $dotfiles

        git submodule update --init --recursive

        if [ $MODE == "1" ]; then
            for file in $files; do
                if [ -L ~/$file ]; then
                    echo "Symlinks exist"
                    exit 1
                fi
            done
        fi

        for file in $files; do
            if [ -a ~/$file ]; then
                mv ~/$file ~/$file".old"
                echo $file" has been renamed to "$file".old"
            fi

            if [ $MODE == "1" ]; then
                ln -s $dotfiles/$file ~/$file
            else
                cp -r $dotfiles/$file ~/$file
            fi
        done
        destruct
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
        destruct
        ;;

    "min")
        if [ -a ~/.vimrc ]; then
            mv ~/.vimrc ~/.vimrc.old
        fi
        cp $dotfiles/.vimrc.min ~/.vimrc
        destruct
        ;;

    *)
        usage
        exit 1
        ;;
esac

