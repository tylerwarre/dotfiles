#!/bin/bash

C_GREEN='\033[0;32m'
C_RED='\033[0;31m'
C_BLUE='\033[0;34m'
C_PURPLE='\033[0;34m'
C_CLEAR='\033[0m'

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
	exec 3>$tmp
	printf "\r[${C_BLUE}*${C_CLEAR}] Installing bash"

	{
		# Create .env file and add GH_TOKEN
		cp ./bash/.env ~/.env
		echo -e "\nexport GH_TOKEN=$token" >> ~/.env
		err=$((err + $?))

		# Backup bashrc
		if [[ ! -f ~/.bashrc.bak ]]; then
			cp ~/.bashrc ~/.bashrc.bak
		else
			echo "bashrc backup already present"
		fi

		# Restore bashrc backup
		cp ~/.bashrc.bak ~/.bashrc
		err=$((err + $?))

		# Append command to bashrc to source .env
		echo -e "\nsource ~/.env" >> ~/.bashrc
		err=$((err + $?))

		# Replace smiley with "@" for tmux PS1
		sed -i 's/☺/@/g' ~/.bashrc
		err=$((err + $?))

		# Add space after '$' in tmux PS1 prompt
		sed -ri 's/(PS1="\\\[\\033\[0;31m\\\].*\$)/\1 /' ~/.bashrc
		err=$((err + $?))

		# Source .env for rest of install script
		source ~/.env
		err=$((err + $?))
	} >&3 2>&3

	# Print module result
	if [[ $err -eq 0 ]]; then
		printf "\r[${C_GREEN}+${C_CLEAR}] Installing bash\n"
	else
		printf "\r[${C_RED}-${C_CLEAR}] Installing bash\n"
	fi

	# Print stdout/stderr if debugging
	if [[ $debug -eq 1 ]]; then
		cat $tmp | pr -T --indent=4
	fi

	# Close file descriptor
	exec 3>&-
}

install_fonts() {
	local err=0
	exec 3>$tmp
	printf "\r[${C_BLUE}*${C_CLEAR}] Installing fonts"

	{
		# Check if fonts are already installed
		local exists=1
		for f in fonts/*; do
			if [[ -f /usr/local/share/fonts/$f ]]; then
				exists=0
				break
			fi
		done

		# Only update fonts if they are not already installed
		if [[ $exists -eq 0 ]]; then
			# copy fonts
			sudo cp fonts/* /usr/local/share/fonts/
			err=$((err + $?))

			# Update font cache
			fc-cache -fv
			err=$((err + $?))
		else
			echo "Fonts are already installed"
		fi
	} >&3 2>&3

	# Print module result
	if [[ $err -eq 0 ]]; then
		printf "\r[${C_GREEN}+${C_CLEAR}] Installing fonts\n"
	else
		printf "\r[${C_RED}-${C_CLEAR}] Installing fonts\n"
	fi

	# Print stdout/stderr if debugging
	if [[ $debug -eq 1 ]]; then
		cat $tmp | pr -T --indent=4
	fi

	# Close file descriptor
	exec 3>&-
}

install_mate-terminal() {
	local err=0
	exec 3>$tmp
	printf "\r[${C_BLUE}*${C_CLEAR}] Installing mate terminal profiles"

	{
		dconf load /org/mate/terminal/ < mate-terminal/mate-terminal-backup.txt
		err=$((err + $?))
	} >&3 2>&3

	# Print module result
	if [[ $err -eq 0 ]]; then
		printf "\r[${C_GREEN}+${C_CLEAR}] Installing mate terminal profiles\n"
	else
		printf "\r[${C_RED}-${C_CLEAR}] Installing mate terminal profiles\n"
	fi

	# Print stdout/stderr if debugging
	if [[ $debug -eq 1 ]]; then
		cat $tmp | pr -T --indent=4
	fi

	# Close file descriptor
	exec 3>&-

}

configure_nvim() {
	local err=0
	exec 3>$tmp
	printf "\r[${C_BLUE}*${C_CLEAR}] Configuring neovim"

	{
		if [[ ! -z "$1" ]]; then
			local version=$1

			# Remove neovim config directory
			rm -rf ~/.config/nvim
			err=$((err + $?))

			# Remove neovim data directory
			rm -rf ~/.local/share/nvim
			err=$((err + $?))

			# Clone neovim config
			git -c advice.detachedHead=false clone --depth 1 --branch $version https://github.com/tylerwarre/nvim.git ~/.config/nvim
			err=$((err + $?))

			# Install system dependancies
			xargs -a ~/.config/nvim/pkglist.txt sudo apt install -y
			err=$((err + $?))

			# Install neovim python venv
			python3 -m venv ~/.config/nvim/nvim-venv
			~/.config/nvim/nvim-venv/bin/python3 -m pip install -r ~/.config/nvim/requirements.txt
			err=$((err + $?))
		else
			echo "No neovim version specified"
		fi
	} >&3 2>&3

	# Print module result
	if [[ $err -eq 0 ]]; then
		printf "\r[${C_GREEN}+${C_CLEAR}] Configuring neovim\n"
	else
		printf "\r[${C_RED}-${C_CLEAR}] Configuring neovim\n"
	fi

	# Print stdout/stderr if debugging
	if [[ $debug -eq 1 ]]; then
		cat $tmp | pr -T --indent=4
	fi

	# Close file descriptor
	exec 3>&-
}

install_nvim() {
	local err=0
	exec 3>$tmp
	printf "\r[${C_BLUE}*${C_CLEAR}] Installing neovim"

	{
		if [[ ! -z "$1" ]]; then
			local version="$1"
			# Only install neovim if it is not present
			if [[ ! -d /opt/nvim ]]; then
				# Download neovim
				curl -L -O https://github.com/neovim/neovim/releases/download/$version/nvim-linux-x86_64.tar.gz
				err=$((err + $?))

				# Install noevim to opt directory
				sudo mkdir /opt/nvim
				sudo tar xf nvim-linux-x86_64.tar.gz --strip-components=1 -C /opt/nvim/
				err=$((err + $?))
				
				# Cleanup archive
				rm nvim-linux-x86_64.tar.gz
				err=$((err + $?))

				# Add neovim to path
				if [[ -f /usr/local/bin/nvim ]]; then
					sudo rm /usr/local/bin/nvim
				fi
				sudo ln -s /opt/nvim/bin/nvim /usr/local/bin/
				err=$((err + $?))
			else
				echo "Neovim already installed"
			fi
		else
			echo "No neovim version specified"
		fi

	} >&3 2>&3

	# Print module result
	if [[ $err -eq 0 ]]; then
		printf "\r[${C_GREEN}+${C_CLEAR}] Installing neovim\n"
	else
		printf "\r[${C_RED}-${C_CLEAR}] Installing neovim\n"
	fi

	# Print stdout/stderr if debugging
	if [[ $debug -eq 1 ]]; then
		cat $tmp | pr -T --indent=4
	fi

	# Close file descriptor
	exec 3>&-

	# Configure neovim
	## Only configure if we haven't failed the install
	if [[ $err -eq 0 ]]; then
		configure_nvim $version
	fi
}

install_treesitter-python() {
	local err=0
	exec 3>$tmp
	printf "\r[${C_BLUE}*${C_CLEAR}] Installing treesitter python grammar"

	{
		if [[ -f ~/.config/nvim/parser/python.so ]]; then
			# Clone python tree-sitter grammar
			curl -L -O https://github.com/tree-sitter/tree-sitter-python/releases/download/v0.25.0/tree-sitter-python.tar.gz
			err=$((err + $?))

			# Extract python grammar repo
			rm -rf ./grammar
			mkdir ./grammar
			tar xf tree-sitter-python.tar.gz -C ./grammar/
			rm tree-sitter-python.tar.gz
			err=$((err + $?))

			# Generate python grammar
			(cd ./grammar && tree-sitter generate)
			err=$((err + $?))

			# Compile python grammar
			(cd ./grammar && tree-sitter build)
			err=$((err + $?))

			# Install python grammar
			mv ./grammar/parser.so ~/.config/nvim/parser/python.so
			err=$((err + $?))

			# Cleanup grammar directory
			rm -r ./grammar
			err=$((err + $?))
		else
			echo "Treesitter python grammar already installed"
		fi
	} >&3 2>&3

	# Print module result
	if [[ $err -eq 0 ]]; then
		printf "\r[${C_GREEN}+${C_CLEAR}] Installing treesitter python grammar\n"
	else
		printf "\r[${C_RED}-${C_CLEAR}] Installing treesitter python grammar\n"
	fi

	# Print stdout/stderr if debugging
	if [[ $debug -eq 1 ]]; then
		cat $tmp | pr -T --indent=4
	fi

	# Close file descriptor
	exec 3>&-
}

install_tmux() {
	local err=0
	exec 3>$tmp
	printf "\r[${C_BLUE}*${C_CLEAR}] Installing tmux"

	{
		# Check for old tmux install
		if [[ -d ~/.tmux ]]; then
			rm -r ~/.tmux
			err=$((err + $?))
			echo "Removing old tmux install"
		fi

		# Copy tmux module to the home folder
		cp -r ./tmux ~/.tmux
		err=$((err + $?))

		# Move the tmux config to the home folder
		mv ~/.tmux/.tmux.conf ~/
		err=$((err + $?))
	} >&3 2>&3

	# Print module result
	if [[ $err -eq 0 ]]; then
		printf "\r[${C_GREEN}+${C_CLEAR}] Installing tmux\n"
	else
		printf "\r[${C_RED}-${C_CLEAR}] Installing tmux\n"
	fi

	# Print stdout/stderr if debugging
	if [[ $debug -eq 1 ]]; then
		cat $tmp | pr -T --indent=4
	fi

	# Close file descriptor
	exec 3>&-
}

install_git() {
	local err=0
	exec 3>$tmp
	printf "\r[${C_BLUE}*${C_CLEAR}] Installing git"

	{
		# Install git config
		cp ./git/.gitconfig ~/
		err=$((err + $?))
	} >&3 2>&3

	# Print module result
	if [[ $err -eq 0 ]]; then
		printf "\r[${C_GREEN}+${C_CLEAR}] Installing git\n"
	else
		printf "\r[${C_RED}-${C_CLEAR}] Installing git\n"
	fi

	# Print stdout/stderr if debugging
	if [[ $debug -eq 1 ]]; then
		cat $tmp | pr -T --indent=4
	fi

	# Close file descriptor
	exec 3>&-
}

install_vim() {
	local err=0
	exec 3>$tmp
	printf "\r[${C_BLUE}*${C_CLEAR}] Installing vim"

	{
		# Check for old vim install
		if [[ -d ~/.vim ]]; then
			rm -r ~/.vim
			err=$((err + $?))
			echo "Removing old vim install"
		fi

		# Copy vim module to the home folder
		cp -r ./vim ~/.vim
		err=$((err + $?))
	} >&3 2>&3

	# Print module result
	if [[ $err -eq 0 ]]; then
		printf "\r[${C_GREEN}+${C_CLEAR}] Installing vim\n"
	else
		printf "\r[${C_RED}-${C_CLEAR}] Installing vim\n"
	fi

	# Print stdout/stderr if debugging
	if [[ $debug -eq 1 ]]; then
		cat $tmp | pr -T --indent=4
	fi

	# Close file descriptor
	exec 3>&-
}

install_gdb() {
	local err=0
	exec 3>$tmp
	printf "\r[${C_BLUE}*${C_CLEAR}] Installing gdb"

	{
		# Install gdb configs
		cp ./gdb/.* ~/
		err=$((err + $?))
	} >&3 2>&3

	# Print module result
	if [[ $err -eq 0 ]]; then
		printf "\r[${C_GREEN}+${C_CLEAR}] Installing gdb\n"
	else
		printf "\r[${C_RED}-${C_CLEAR}] Installing gdb\n"
	fi

	# Print stdout/stderr if debugging
	if [[ $debug -eq 1 ]]; then
		cat $tmp | pr -T --indent=4
	fi

	# Close file descriptor
	exec 3>&-
}

configure_pwnbox-timer() {
	local err=0
	exec 3>$tmp
	printf "\r[${C_BLUE}*${C_CLEAR}] Configuring Pwnbox timer"

	{
		# Check if the cronjob exists already
		local exists=$(crontab -l | grep -c "Pwnbox")
		err=$((err + $?))

		# Only add conjob if it does not exist
		if [[ $exists -eq 0 ]]; then
			# Get login session start minute
			local startup=$(
				loginctl session-status |
					grep -Po "(?<=Since: [A-Za-z]{3} \d{4}-\d{2}-\d{2} \d{2}:)\d+(?=:\d+)" |
					sed "s/^0*//"
			)
			err=$((err + $?))

			# Add 10 mintues to minute of the hour to offset so we don't refresh
			# to early
			if [[ $startup -gt 49 ]]; then
				startup=$(((startup + 10) % 60))
			else
				startup=$((startup + 10))
			fi
			err=$((err + $?))

			# Configure notification for every minute of the hour (offset by 10 minutes) from
			# the session start
			(crontab -l 2>/dev/null;
				echo "$startup * * * * /usr/bin/notify-send -u critical -t 25000 'Pwnbox' 'Refresh your session'"
			) | crontab -
			err=$((err + $?))
		else
			echo "Pwnbox timer cronjob already present"
		fi
	} >&3 2>&3

	# Print module result
	if [[ $err -eq 0 ]]; then
		printf "\r[${C_GREEN}+${C_CLEAR}] Configuring Pwnbox timer\n"
	else
		printf "\r[${C_RED}-${C_CLEAR}] Configuring Pwnbox timer\n"
	fi

	# Print stdout/stderr if debugging
	if [[ $debug -eq 1 ]]; then
		cat $tmp | pr -T --indent=4
	fi

	# Close file descriptor
	exec 3>&-
}

get_htb-notes() {
	local err=0
	exec 3>$tmp
	printf "\r[${C_BLUE}*${C_CLEAR}] Getting HTB notes"

	{
		# Clone HTB notes if not present
		if [[ ! -d ~/htb ]]; then
			git clone --quiet --depth 1 "https://tylerwarre:$token@github.com/tylerwarre/htb.git" ~/htb
			err=$((err + $?))
		else
			echo "HTB notes already downloaded"
		fi
	} >&3 2>&3

	# Print module result
	if [[ $err -eq 0 ]]; then
		printf "\r[${C_GREEN}+${C_CLEAR}] Getting HTB notes\n"
	else
		printf "\r[${C_RED}-${C_CLEAR}] Getting HTB notes\n"
	fi

	# Print stdout/stderr if debugging
	if [[ $debug -eq 1 ]]; then
		cat $tmp | pr -T --indent=4
	fi

	# Close file descriptor
	exec 3>&-
}

get_wiki() {
	local err=0
	exec 3>$tmp
	printf "\r[${C_BLUE}*${C_CLEAR}] Getting Wiki"

	{
		# Clone Wiki if not present
		if [[ ! -d ~/wiki ]]; then
			git clone --quiet --depth 1 "https://tylerwarre:$token@github.com/tylerwarre/wiki.git" ~/wiki
			err=$((err + $?))
		else
			echo "Wiki already downloaded"
		fi
	} >&3 2>&3

	# Print module result
	if [[ $err -eq 0 ]]; then
		printf "\r[${C_GREEN}+${C_CLEAR}] Getting Wiki\n"
	else
		printf "\r[${C_RED}-${C_CLEAR}] Getting Wiki\n"
	fi

	# Print stdout/stderr if debugging
	if [[ $debug -eq 1 ]]; then
		cat $tmp | pr -T --indent=4
	fi

	# Close file descriptor
	exec 3>&-
}

configure_vpn() {
	local err=0
	exec 3>$tmp
	printf "\r[${C_BLUE}*${C_CLEAR}] Configuring VPN"

	{
		if [[ "$do_vpn" == "y" ]]; then
			if [[ -f ~/lab-vpn.conf ]]; then
				sudo systemctl stop openvpn@$(whoami)
				err=$((err + 1))

				sudo mv ~/lab-vpn.conf /etc/openvpn/client/
				err=$((err + 1))

				sudo systemctl start openvpn-client@lab-vpn
				err=$((err + 1))
			else
				echo "Please provide vpn config at ~/lab-vpn.conf"
				err=$((err + 1))
			fi
		fi
	} >&3 2>&3

	# Print module result
	if [[ $err -eq 0 ]]; then
		printf "\r[${C_GREEN}+${C_CLEAR}] Configuring VPN\n"
	else
		printf "\r[${C_RED}-${C_CLEAR}] Configuring VPN\n"
	fi

	# Print stdout/stderr if debugging
	if [[ $debug -eq 1 ]]; then
		cat $tmp | pr -T --indent=4
	fi

	# Close file descriptor
	exec 3>&-
}

# TODO: Change to use custome file descriptor for grouped commands instead
if [[ "$1" == "--debug" ]]; then
	debug=1
else
	debug=0
fi

tmp=$(mktemp)

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
install_nvim "v0.12.4"
install_treesitter-python
configure_vpn

echo "Don't forget to resetart your terminal ;)"
