#!/bin/sh

# Change directory
SCRIPT_DIR=$(dirname -- "$( readlink -f -- "$0"; )") && cd "$SCRIPT_DIR" || exit

if [ "$XDG_CURRENT_DESKTOP" = "GNOME" ]; then # Install fragments - Torrent client made for GNOME
  if command -v apt-get > /dev/null; then # Install for debian-based distros
    if apt-cache search 'fragments' > /dev/null; then
      sudo apt-get install -y fragments
    else
      if ! command -v snap > /dev/null; then
        ./install-snap.sh
      fi
      sudo snap install fragments
    fi
  fi
else # Install qbittorrent - Just another torrent client
  if command -v apt-get > /dev/null; then # Install for debian-based distros
    sudo apt-get install -y qbittorrent
  fi
fi
