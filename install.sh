#!/bin/bash

# Install vim
cp -r ./vim ~/.vim

# Install tmux
cp -r ./tmux ~/.tmux
cp ~/.tmux/.tmux.conf ~/

# Install git
cp ./git/.gitconfig ~/

# Fetch HTB Notes
git clone --depth 1 https://github.com/tylerwarre/htb.git
mv htb ~/

# Fetch Wiki
git clone --depth 1 https://github.com/tylerwarre/wiki.git
mv wiki ~/

# Install gdb
cp ./gdb/* ~/

# Install bash
cat ./bash/.bashrc >> ~/.bashrc
