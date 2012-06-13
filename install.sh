#!/bin/sh

# Source directory
REPO_DIR=`pwd`

echo "Submodule init and update"
git submodule init
git submodule update

echo "Start create links"
ln -snf $REPO_DIR/.zshrc ~/.zshrc
ln -snf $REPO_DIR/.zsh ~/.zsh
ln -snf $REPO_DIR/.tmux.conf ~/.tmux.conf
ln -snf $REPO_DIR/.screenrc ~/.screenrc
ln -snf $REPO_DIR/.newsbeuter ~/.newsbeuter

if ! [[ -d ~/.config ]]; then mkdir ~/.config; fi
ln -snf $REPO_DIR/.config/awesome ~/.config/awesome
