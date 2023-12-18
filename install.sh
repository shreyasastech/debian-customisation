#!/bin/sh

# ██████╗ ███████╗██████╗ ██╗ █████╗ ███╗   ██╗       ██████╗██╗   ██╗███████╗████████╗ ██████╗ ███╗   ███╗
# ██╔══██╗██╔════╝██╔══██╗██║██╔══██╗████╗  ██║      ██╔════╝██║   ██║██╔════╝╚══██╔══╝██╔═══██╗████╗ ████║
# ██║  ██║█████╗  ██████╔╝██║███████║██╔██╗ ██║█████╗██║     ██║   ██║███████╗   ██║   ██║   ██║██╔████╔██║
# ██║  ██║██╔══╝  ██╔══██╗██║██╔══██║██║╚██╗██║╚════╝██║     ██║   ██║╚════██║   ██║   ██║   ██║██║╚██╔╝██║
# ██████╔╝███████╗██████╔╝██║██║  ██║██║ ╚████║      ╚██████╗╚██████╔╝███████║   ██║   ╚██████╔╝██║ ╚═╝ ██║██╗
# ╚═════╝ ╚══════╝╚═════╝ ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝       ╚═════╝ ╚═════╝ ╚══════╝   ╚═╝    ╚═════╝ ╚═╝     ╚═╝╚═╝

# Check if script is run as root
if [ "$(id -u)" -eq 0 ]; then
  echo "You must NOT be a root user when running this script, please run ./install.sh" 2>&1
  exit 1
fi

# Change directory
SCRIPT_DIR=$(dirname -- "$( readlink -f -- "$0"; )") && cd "$SCRIPT_DIR" || exit

# Updating system & installing programs
sudo apt-get -y install ufw man git gparted vlc shellcheck curl wget python-is-python3 obs-studio kdeconnect keepassxc qbittorrent

# My custom scripts
./scripts/update-system.sh # Updating installed programs
./scripts/brave.sh # brave-browser
./scripts/github-desktop.sh # github-desktop for linux
./scripts/gnome.sh # GNOME Desktop Environment Customisations
./scripts/librewolf.sh # firefox fork that is truely the best (IMO)
./scripts/nala.sh # apt, but colorful
./scripts/onlyoffice.sh # office suite
./scripts/setup-antix.sh # Antix Linux Customisations
./scripts/snap.sh # snap package manager
./scripts/vscodium.sh # open source vscode
./scripts/shell-customization.sh # bash/fish/zsh customizations

# Enabling firewall
sudo ufw enable
if command -v kdeconnect-cli > /dev/null || gnome-extensions list | grep -q gsconnect; then
  sudo ufw allow 1714:1764/udp
  sudo ufw allow 1714:1764/tcp
  sudo ufw reload
fi

# Change Grub Timeout
if [ -f /etc/default/grub ]; then
  sudo sed -i "/GRUB_TIMEOUT/ c\GRUB_TIMEOUT=2" /etc/default/grub
  sudo update-grub
fi

# Change systemd-boot Timeout
if [ -f /boot/loader/loader.conf ]; then
  sudo sed -i "/timeout/ c\timeout 1" /boot/loader/loader.conf
fi

# Lower swappiness value for better utilization of RAM
sudo sysctl vm.swappiness=10

# Add script to toggle wifi
sudo cp scripts/wifi-toggle.sh /usr/local/bin/wifi-toggle

# Done
echo "Installation is complete. Reboot your system for the changes to take place."
