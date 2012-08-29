#!/bin/sh

# Source directory
REPO_DIR=`pwd`

echo "Submodule init and update"
git submodule init
git submodule update

echo "Start create links"
for file in ".zshrc" ".zsh" ".tmux.conf" ".screenrc" ".newsbeuter" ".Xdefaults" ".xcolors"; do
    ln -snf $REPO_DIR/$file $HOME/$file
done

if ! [[ -d ~/.config ]]; then mkdir ~/.config; fi
ln -snf $REPO_DIR/.config/awesome ~/.config/awesome
