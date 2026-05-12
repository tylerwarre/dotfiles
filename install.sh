#!/bin/bash

# Install vim
cp -r ./vim ~/.vim

# Install tmux
cp -r ./tmux ~/.tmux
cp ~/.tmux/.tmux.conf ~/

# Install git
cp ./git/.gitconfig ~/
git clone https://github.com/tylerwarre/htb.git
mv htb ~/

# Install gdb
cp ./gdb/* ~/

# Install bash
cat ./bash/.bashrc >> ~/.bashrc
