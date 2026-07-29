#!/bin/bash

get_options() {
	if [[ -n $GH_TOKEN ]]; then
		token=$GH_TOKEN
	else
		read -sp "GH_TOKEN: " token
		echo ""
	fi
	read -p "Install vpn? (y/n): " do_vpn
}

install_bash() {
	local err=0
	printf "\r[?] Installing bash"

	{
		cp ./bash/.env ~/.env
		echo -e "\nexport GH_TOKEN=$token" >> ~/.env
		err=$((err + $?))

		if [[ ! -f ~/.bashrc.bak ]]; then
			cp ~/.bashrc ~/.bashrc.bak
		fi
		cp ~/.bashrc.bak ~/.bashrc
		err=$((err + $?))

		echo -e "\nsource ~/.env" >> ~/.bashrc
		err=$((err + $?))

		source ~/.env
		err=$((err + $?))
	}

	if [[ $err -eq 0 ]]; then
		printf "\r[+] Installing bash\n"
	else
		printf "\r[-] Installing bash\n"
	fi
}

install_fonts() {
	sudo cp fonts/* /usr/local/share/fonts/
}

install_mater-terminal() {
	dconf load /org/mate/terminal/ < mate-terminal/mate-terminal-backup.txt
}

install_vim() {
	cp -r ./vim ~/.vim
}

configure_nvim() {
	rm -rf ~/.config/nvim
	rm -rf ~/.local/share/nvim
	rm -r /usr/local/bin/nvim
	git clone --depth 1 --branch v0.12.4 https://github.com/tylerwarre/nvim.git ~/.config/nvim
	xargs -a ~/.config/nvim/pkglist.txt sudo apt install -y
}

install_nvim() {
	curl -L -O https://github.com/neovim/neovim/releases/download/v0.12.4/nvim-linux-x86_64.tar.gz
	tar xf nvim-linux-x86_64.tar.gz
	rm nvim-linux-x86_64.tar.gz
	sudo mv nvim-linux-x86_64/ /opt/nvim/
	sudo ln -s /opt/nvim/bin/nvim /usr/local/bin/

	configure_nvim
}

install_tmux() {
	cp -r ./tmux ~/.tmux
	cp ~/.tmux/.tmux.conf ~/
}

install_git() {
	cp ./git/.gitconfig ~/
}

install_gdb() {
	cp ./gdb/* ~/
}

configure_pwnbox-timer() {
	startup=$(loginctl session-status | grep -Po "(?<=Since: [A-Za-z]{3} \d{4}-\d{2}-\d{2} \d{2}:)\d+(?=:\d+)" | sed "s/^0*//")
	(crontab -l 2>/dev/null; echo "$((startup + 10)) * * * * /usr/bin/notify-send -u critical -t 25000 'Pwnbox' 'Refresh your session'") | crontab -
}

get_htb-notes() {
	echo "https://tylerwarre:$token@github.com/tylerwarre/htb.git"
	git clone --depth 1 "https://tylerwarre:$token@github.com/tylerwarre/htb.git"
	mv htb ~/
}

get_wiki() {
	git clone --depth 1 "https://tylerwarre:$token@github.com/tylerwarre/wiki.git"
	mv wiki ~/
}

install_vpn() {
	if [[ "$do_vpn" == "y" ]]; then
		sudo systemctl stop openvpn@$(whoami)
		sudo mv ~/lab-vpn.conf /etc/openvpn/client/
		sudo systemctl start openvpn-client@lab-vpn
	fi
}

# TODO: Change to use custome file descriptor for grouped commands instead
if [[ "$1" == "--debug" ]]; then
	output=""
else
	output="> /dev/null 2>&1"
fi

get_options
install_bash
get_htb-notes
get_wiki
configure_pwnbox-timer
install_fonts
install_mate-terminal
install_tmux
install_vim
install_gdb
install_git
install_nvim
install_vpn
