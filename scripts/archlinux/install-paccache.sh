#!/bin/sh

# Check if the OS is Arch Linux
if ! command -v pacman > /dev/null; then
  exit
fi

# Install pacman-contrib meta-package that contains paccache program
sudo pacman -S --noconfirm pacman-contrib

# Enable auto clearing pacman cache using paccache program
echo "[Trigger]                              
Operation = Upgrade
Operation = Install
Operation = Remove
Type = Package
Target = *
[Action]
Description = Cleaning pacman cache...
When = PostTransaction
Exec = /usr/bin/paccache -rk1" | sudo tee /etc/pacman.d/hooks/clean-pkg-cache.hook > /dev/null
