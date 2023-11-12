#!/bin/bash

# Function to setup XDG user dirs
function setupXDGUserDirs {

	for dirname in "$@"; do
	local newdirname="$(echo "$dirname" | awk '{print tolower($0)}')"

	if [ -d "$dirname" ]; then
		mv "$dirname" "$newdirname"
	else
		mkdir "$newdirname"
	fi
	done

	cp ../dotfiles/user-dirs.dirs ~/.config/
	xdg-user-dirs-update

}

# Function to customise bash shell
function customiseBash {

    sudo apt-get -y install bash-completion make gawk git

	# Create necessary directories
	mkdir -p ~/.config/lscolors

	# Neofetch for root shell
	sudo sed -i '$ a\\n\#Neofetch\nif test -f "/usr/bin/neofetch"; then\n  neofetch\nfi' /root/.bashrc

	# Copy necessary files
	cp ../dotfiles/.bashrc ~/
	cp ../dotfiles/lscolors.sh ~/.config/lscolors/

}

# Function to customise fish shell
function customiseFish {

  sudo apt-get -y install fish python-is-python3

	# Create necessary directories
	mkdir -p ~/.config/fish
	mkdir -p ~/.config/lscolors

	# Copy necessary files
	cp ../dotfiles/lscolors.csh ~/.config/lscolors/ # Adding some spash of colors to the good old ls command
	cp ../dotfiles/config.fish ~/.config/fish/

}

# Function to customise zsh shell
function customiseZsh {

  sudo apt-get -y install zsh zsh-autosuggestions zsh-syntax-highlighting

	# Create necessary directories
	mkdir -p ~/.config/lscolors

	# Copy necessary files
	cp ../dotfiles/.zshrc ~/
	cp ../dotfiles/lscolors.sh ~/.config/lscolors/

}

# Shell choice
function shellChoice {

	echo "Which shell you prefer to customise?"
	echo "[1] Bash"
	echo "[2] Fish"
	echo "[3] Zsh"
	echo "[4] None"
	read -r -p "Choose an option (1/2/3/4) : " shell_choice
	if ! [[ "$shell_choice" =~ ^[1-4]$ ]]; then
		echo -e "Invalid Choice..!!!\n"
		shellChoice
	fi

}

# Check if variable is set
if [[ -z ${shell_choice} ]]; then
	shellChoice
fi

# Change directory
SCRIPT_DIR=$(dirname -- "$( readlink -f -- "$0"; )") && cd "$SCRIPT_DIR" || exit

# Installation
sudo apt-get update && sudo apt-get -y install autojump bat neofetch trash-cli wget tldr fzf command-not-found git micro btop exa
case $shell_choice in
    1)
        customiseBash && while ! chsh -s /usr/bin/bash; do :; done;;
    2)
        customiseFish && while ! chsh -s /usr/bin/fish; do :; done;;
    3)
        customiseZsh && while ! chsh -s /usr/bin/zsh; do :; done;;
esac
setupXDGUserDirs ~/Desktop ~/Documents ~/Downloads ~/Music ~/Pictures ~/Templates ~/Videos ~/Public

# Shell color scripts
(cd ~ && git clone https://github.com/shreyas-a-s/shell-color-scripts.git && cd shell-color-scripts/ && sudo make install)

# Add password feedback (asterisks) for sudo
echo 'Defaults    pwfeedback' | sudo tee -a /etc/sudoers > /dev/null

# Set default text editor
if [ -f /usr/bin/micro ]; then
	sudo update-alternatives --set editor /usr/bin/micro
else
	sudo update-alternatives --set editor /usr/bin/nano
fi

# Copy config file for micro
cp ../dotfiles/settings.json ~/.config/micro/

# Update database of command-not-found
sudo update-command-not-found
sudo apt update
