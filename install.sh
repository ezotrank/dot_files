#!/bin/sh

# Source directory
REPO_DIR=`pwd`

echo "Submodule init and update"
git submodule init
git submodule update

echo "Start create links"
for file in ".zshrc" ".zsh" ".ackrc", ".vimrc"; do
    ln -snf $REPO_DIR/$file $HOME/$file
done
