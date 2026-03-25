#!/bin/bash

# Install vim
cp -r ./vim ~/.vim

# Install tmux
cp -r ./tmux ~/.tmux
mv ~/.tmux/.tmux.conf ~/

# Install git
cp ./git/.gitconfig ~/
git clone https://github.com/tylerwarre/htb.git
