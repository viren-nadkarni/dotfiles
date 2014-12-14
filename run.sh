#!/bin/bash
set -e

dotfiles="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
files=".aliases .bashrc .gitconfig .nanorc .vimrc .vim"

case $1 in
    "init")
        cd $dotfiles

        git submodule update --init --recursive
        
        for file in $files; do
            if [ -L ~/$file ]; then
                echo "Symlinks exist"
                exit 1
            fi
        done

        echo "Existing dotfiles will be renamed to *.old"
        for file in $files; do
            if [ -a ~/$file ]; then
                mv ~/$file ~/$file".old"
            fi
            ln -s $dotfiles/$file ~/$file
        done
        ;;

    "update")
        git submodule foreach git pull origin master
        ;;

    *)
        echo "Usage: $0 <option>"
        echo "  init      setup symlinks for dotfiles"
        echo "  update    update vim bundles"

        exit 1
        ;;
esac

