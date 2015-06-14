#!/bin/sh

here=$PWD

for file in ".gitconfig" ".mailcap" ".muttrc" ".sqliterc" ".vimrc" ".zshrc"; do
    if [[ $(readlink -f $HOME/$file) != $(readlink -f $here/$file) ]]; then
        ln -i -s -T $here/$file $HOME/$file
        echo "linked $file"
    fi
done
