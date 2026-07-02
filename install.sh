#!/bin/bash

# Get github token
read -sp "test: " token

# Install vim
cp -r ./vim ~/.vim

# Install neovim
curl -L -O https://github.com/neovim/neovim/releases/download/v0.12.3/nvim-linux-x86_64.tar.gz
tar xf nvim-linux-x86_64.tar.gz
rm nvim-linux-x86_64.tar.gz
sudo mv nvim-linux-x86_64/ /opt/nvim/
sudo ln -s /opt/nvim/bin/nvim /usr/local/bin/

# Configure neovim
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -r /usr/local/bin/nvim
git clone --depth 1 https://github.com/tylerwarre/nvim.git ~/.config/nvim
xargs -a ~/.config/nvim/pkglist.txt sudo apt install -y

# Install tmux
cp -r ./tmux ~/.tmux
cp ~/.tmux/.tmux.conf ~/

# Install git
cp ./git/.gitconfig ~/

# Fetch HTB Notes
echo "https://tylerwarre:$token@github.com/tylerwarre/htb.git"
git clone --depth 1 "https://tylerwarre:$token@github.com/tylerwarre/htb.git"
mv htb ~/

# Fetch Wiki
git clone --depth 1 "https://tylerwarre:$token@github.com/tylerwarre/wiki.git"
mv wiki ~/

# Install gdb
cp ./gdb/* ~/

# Init VPN
sudo systemctl stop openvpn@$(whoami)
sudo mv ~/lab-vpn.conf /etc/openvpn/client/
sudo systemctl start openvpn-client@lab-vpn

# Install bash
echo "" >> ~/.bashrc
cat ./bash/.bashrc >> ~/.bashrc
