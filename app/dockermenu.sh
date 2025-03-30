#!/bin/bash

# Get the machine hardware name
architecture=$(uname -m)

# Check if the architecture is x86_64 (AMD/Intel)
if [ "$architecture" != "x86_64" ]; then
    echo "This script only runs on AMD or Intel (x86_64) CPUs, not on $architecture."
    exit 1
fi

clear 
# === BUA Detection ===
if [ -d "/userdata/system/add-ons" ]; then
    rm -f /userdata/roms/ports/Profork.sh
    rm -r /userdata/roms/ports/Profork.sh.keys
    clear
    echo "BUA detected."
    echo "Dual installs not supported"
    echo "Goodbye."
    echo
    exit 0
fi
# Function to display animated title with colors
animate_title() {
    local text="DOCKER, PODMAN, & CONTAINERS (h/t UUREEL)"
    local delay=0.03
    local length=${#text}

    echo -ne "\e[1;36m"  # Set color to cyan
    for (( i=0; i<length; i++ )); do
        echo -n "${text:i:1}"
        sleep $delay
    done
    echo -e "\e[0m"  # Reset color
}

# Function to display animated border
animate_border() {
    local char="#"
    local width=50

    for (( i=0; i<width; i++ )); do
        echo -n "$char"
        sleep 0.02
    done
    echo
}

# Function to display controls
display_controls() {
    echo -e "\e[1;32m"  # Set color to green
    echo "K/B Controls + Gamepad Controls when launched from ports:"
    echo "  Navigate with up-down-left-right"
    echo "  Select app with A/B/SPACE and execute with Start/X/Y/ENTER"
    echo -e "\e[0m"  # Reset color
    sleep 4
}

# Function to display loading animation
loading_animation() {
    local delay=0.1
    local spinstr='|/-\'
    echo -n "Loading "
    while :; do
        for (( i=0; i<${#spinstr}; i++ )); do
            echo -ne "${spinstr:i:1}"
            echo -ne "\010"
            sleep $delay
        done
    done &
    spinner_pid=$!
    sleep 3
    kill $spinner_pid
    echo "Done!"
}

# Main script execution
clear
animate_border
animate_title
animate_border
display_controls

# Define an associative array for app names and their install commands
declare -A apps
apps=(
    # ... (populate with your apps as shown before)
    ["ARCH-CONTAINER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/steam/steam.sh | bash"
    ["ANDROID/BLISS-OS/DOCKER/QEMU"]="curl -Ls https://github.com/trashbus99/profork/raw/master/docker/bliss_install.sh | bash" 
    ["CASAOS/DOCKER/RECOMMENDED-VERSION"]="curl -Ls https://github.com/trashbus99/profork/raw/master/docker/casa2.sh | bash"
    ["CASAOS/FULL-CONTAINER/DEBIAN/XFCE"]="curl -Ls https://github.com/trashbus99/profork/raw/master/docker/casa.sh | bash"
    ["EMBY-SERVER/DOCKER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/docker/emby.sh | bash"
    ["JELLYFIN-SERVER/DOCKER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/docker/jellyfin.sh | bash"
    ["LINUX-DESKTOPS-RDP/DOCKER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/docker/rdesktop.sh | bash | bash"
    ["NETBOOT-XYZ-SERVER/DOCKER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/docker/netboot.sh | bash"
    ["NEXTCLOUD-SERVER/DOCKER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/docker/nextcloud.sh | bash" 
    ["PLEX-SERVER/DOCKER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/docker/plex.sh | bash"
    ["DOCKER/PODMAN/PORTAINER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/docker/install.sh | bash"
    ["UMBREL-OS/DOCKER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/docker/umbrel.sh | bash"
    ["WINDOWS-VMS/DOCKER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/docker/win.sh | bash"
    ["LINUX-DESKTOPS-WEB/DOCKER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/docker/webtop.sh | bash"
    ["SYSTEMTOOLS-WETTY-GLANCES-FILEMANAGER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/docker/systools.sh | bash"

    # Add other apps here
)

# Prepare array for dialog command, sorted by app name
app_list=()
for app in $(printf "%s\n" "${!apps[@]}" | sort); do
    app_list+=("$app" "" OFF)
done

# Show dialog checklist
cmd=(dialog --separate-output --checklist "Select applications to install or update:" 22 76 16)
choices=$("${cmd[@]}" "${app_list[@]}" 2>&1 >/dev/tty)

# Check if Cancel was pressed
if [ $? -eq 1 ]; then
    echo "Installation cancelled."
    exit
fi

# Install selected apps
for choice in $choices; do
    applink="$(echo "${apps[$choice]}" | awk '{print $3}')"
    rm /tmp/.app 2>/dev/null
    wget --tries=10 --no-check-certificate --no-cache --no-cookies -q -O "/tmp/.app" "$applink"
    if [[ -s "/tmp/.app" ]]; then 
        dos2unix /tmp/.app 2>/dev/null
        chmod 777 /tmp/.app 2>/dev/null
        clear
        loading_animation
        sed 's,:1234,,g' /tmp/.app | bash
        echo -e "\n\n$choice DONE.\n\n"
    else 
        echo "Error: couldn't download installer for ${apps[$choice]}"
    fi
done

# Reload ES after installations
curl -L https://github.com/trashbus99/profork/raw/master/app/mainmenu.sh | bash
