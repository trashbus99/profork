#!/bin/bash

# Initial setup
BACKTITLE="Docker Webtop Container Setup"
architecture=$(uname -m)
DEFAULT_HTTP_PORT=3000
DEFAULT_HTTPS_PORT=3001

# Check system architecture
if [ "$architecture" != "x86_64" ]; then
    dialog --title "Architecture Error" --msgbox "This script only runs on AMD or Intel (x86_64) CPUs, not on $architecture." 10 50
    clear
    exit 1
fi

# Check for Docker binary and running service
if ! command -v docker &> /dev/null || ! docker info &> /dev/null; then
    dialog --title "Docker Installation" --infobox "Docker is not installed or the service is not running. Installing Docker..." 10 50
    sleep 2  # Gives user time to read the message
    curl -L https://github.com/trashbus99/profork/raw/master/docker/install.sh | bash
    # Verify Docker installation and service
    if ! command -v docker &> /dev/null || ! docker info &> /dev/null; then
        dialog --title "Docker Installation Error" --msgbox "Docker installation failed or the service did not start. Please install and configure Docker manually." 10 50
        clear
        exit 1
    fi
fi

# Function to check if a port is in use
is_port_in_use() {
    netstat -tuln 2>/dev/null | grep ":$1 " > /dev/null
    return $?
}

# Function to find the next available port starting from a given port
find_next_available_port() {
    local port=$1
    while is_port_in_use $port; do
        port=$((port + 1))
    done
    echo $port
}

# Check and set the HTTP port for Webtop
HTTP_PORT=$DEFAULT_HTTP_PORT
if is_port_in_use $HTTP_PORT; then
    HTTP_PORT=$(find_next_available_port $HTTP_PORT)
fi

# Check and set the HTTPS port for Webtop
# We assume HTTPS port to be HTTP_PORT+1 by default.
HTTPS_PORT=$DEFAULT_HTTPS_PORT
if is_port_in_use $HTTPS_PORT; then
    HTTPS_PORT=$(find_next_available_port $HTTPS_PORT)
fi

# Allow user to change the default HTTP port if needed
HTTP_PORT=$(dialog --stdout --inputbox "Enter the Webtop HTTP port [Default: $HTTP_PORT]:" 8 45 "$HTTP_PORT") || exit
clear

# Allow user to change the default HTTPS port if needed
HTTPS_PORT=$(dialog --stdout --inputbox "Enter the Webtop HTTPS port [Default: $HTTPS_PORT]:" 8 45 "$HTTPS_PORT") || exit
clear

# Desktop Environment / Flavor selection for Webtop
# Available tags include: latest (XFCE Alpine), ubuntu-xfce, fedora-xfce, arch-xfce,
# alpine-kde, ubuntu-kde, fedora-kde, arch-kde, alpine-mate, ubuntu-mate, fedora-mate, arch-mate,
# alpine-i3, ubuntu-i3, fedora-i3, arch-i3, etc.
DESKTOP_ENVIRONMENT=$(dialog --stdout --menu "Choose a Webtop flavor (desktop environment):" 20 60 15 \
"latest" "XFCE Alpine (default)" \
"ubuntu-xfce" "XFCE Ubuntu" \
"fedora-xfce" "XFCE Fedora" \
"arch-xfce" "XFCE Arch" \
"alpine-kde" "KDE Alpine" \
"ubuntu-kde" "KDE Ubuntu" \
"fedora-kde" "KDE Fedora" \
"arch-kde" "KDE Arch" \
"alpine-mate" "MATE Alpine" \
"ubuntu-mate" "MATE Ubuntu" \
"fedora-mate" "MATE Fedora" \
"arch-mate" "MATE Arch" \
"alpine-i3" "i3 Alpine" \
"ubuntu-i3" "i3 Ubuntu" \
"fedora-i3" "i3 Fedora" \
"arch-i3" "i3 Arch") || exit
clear

# Docker run command for Webtop
docker run -d \
  --name=webtop \
  --security-opt seccomp=unconfined \  # Optional, based on app requirements
  -e PUID=$(id -u) \
  -e PGID=$(id -g) \
  -e TZ=$(cat /etc/timezone 2>/dev/null || echo "Etc/UTC") \
  -e SUBFOLDER=/ \  # Optional: change if using a reverse proxy subfolder
  -e TITLE="Webtop" \  # Optional: sets the browser page title
  -p $HTTP_PORT:3000 \
  -p $HTTPS_PORT:3001 \
  -v /path/to/data:/config \
  -v /var/run/docker.sock:/var/run/docker.sock \  # Optional: for Docker in container
  --device /dev/dri:/dev/dri \  # Optional: for GPU acceleration (if available)
  --shm-size="1gb" \  # Optional
  --restart unless-stopped \
  lscr.io/linuxserver/webtop:$DESKTOP_ENVIRONMENT

# Final message to the user
MSG="Your Webtop docker container has been started with the following configurations:\n
- Desktop Environment: $DESKTOP_ENVIRONMENT\n
- HTTP Port: $HTTP_PORT\n
- HTTPS Port: $HTTPS_PORT\n
\nBy default, if HTTP authentication is enabled, the credentials are:\n  Username: abc\n  Password: abc\n
Access Webtop via your browser at:\n  http://yourhost:$HTTP_PORT/\n  https://yourhost:$HTTPS_PORT/\n
Manage the container via CLI or Portainer as needed."
dialog --title "Webtop Setup Complete" --msgbox "$MSG" 20 70
clear
