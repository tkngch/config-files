#!/bin/bash

here=$PWD

for file in ".clang-format" ".gitconfig" ".mailcap" ".muttrc" ".Rprofile" ".sqliterc" ".tmux.conf" ".vimrc" ".Xresources" ".xinitrc" ".zshrc";
do
    if [[ $(readlink -f "$HOME/$file") != $(readlink -f "$here/$file") ]]; then
        ln -i -s -T "$here/$file" "$HOME/$file"
        echo "linked $file"
    fi
done

for file in "user-dirs.dirs";
do
    ln -i -s -T "$here/$file" "$XDG_CONFIG_HOME/$file"
    echo "linked $file"
done

for file in emacs.d/*;
do
    ln -i -s -T "$here/$file" "$HOME/.emacs.d/$(basename "$file")"
done

ln -i -s -T "$here/mimeapps.list" "$HOME/.config/mimeapps.list"
ln -i -s -T "$here/null.desktop" "$HOME/.local/share/applications/null.desktop"

mkdir -p "$XDG_CONFIG_HOME/nvim"
ln -i -s -T "$here/init.vim" "$XDG_CONFIG_HOME/nvim/init.vim"
