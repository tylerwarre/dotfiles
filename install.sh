#!/bin/bash

function get_options {

}

# Get github token
read -sp "test: " token
read -p "Install vpn? (y/n): " do_vpn

# Install fonts
#sudo cp fonts/* /usr/local/share/fonts/

# Install mate-terminal
dconf load /org/mate/terminal/ < mate-terminal/mate-terminal-backup.txt

# Install vim
cp -r ./vim ~/.vim

# Install neovim
curl -L -O https://github.com/neovim/neovim/releases/download/v0.12.4/nvim-linux-x86_64.tar.gz
tar xf nvim-linux-x86_64.tar.gz
rm nvim-linux-x86_64.tar.gz
sudo mv nvim-linux-x86_64/ /opt/nvim/
sudo ln -s /opt/nvim/bin/nvim /usr/local/bin/

# Configure neovim
rm -rf ~/.config/nvim
rm -rf ~/.local/share/nvim
rm -r /usr/local/bin/nvim
git clone --depth 1 --branch v0.12.4 https://github.com/tylerwarre/nvim.git ~/.config/nvim
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
if [[ "$do_vpn" == "y" ]]; then
  sudo systemctl stop openvpn@$(whoami)
  sudo mv ~/lab-vpn.conf /etc/openvpn/client/
  sudo systemctl start openvpn-client@lab-vpn
fi

# Install bash
echo "" >> ~/.bashrc
cat ./bash/.bashrc >> ~/.bashrc

# TMP
# Get Startup time: startup=$(loginctl session-status | grep -Po "(?<=Since: [A-Za-z]{3} \d{4}-\d{2}-\d{2} \d{2}:)\d+(?=:\d+)" | sed "s/^0*//")
# Install crontab: (crontab -l 2>/dev/null; echo "$((startup + 10)) * * * * /usr/bin/notify-send -u critical -t 25000 'Pwnbox' 'Refresh your session'") | crontab -
