#!/bin/bash

clear

# Function to display animated title with colors
animate_title() {
    local text="Tools (h/t UUREEL)"
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
    echo " - Navigate with up-down-left-right"
    echo " - Execute with Start/X/Y/ENTER"
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

# Function to run app installation
run_installation() {
    applink="$(echo "${apps[$1]}" | awk '{print $3}')"
    rm /tmp/.app 2>/dev/null
    wget --tries=10 --no-check-certificate --no-cache --no-cookies -q -O "/tmp/.app" "$applink"
    if [[ -s "/tmp/.app" ]]; then 
        dos2unix /tmp/.app 2>/dev/null
        chmod 777 /tmp/.app 2>/dev/null
        clear
        loading_animation
        sed 's,:1234,,g' /tmp/.app | bash
        echo -e "\n\n$1 DONE.\n\n"
    else 
        echo "Error: couldn't download installer for ${apps[$1]}"
    fi
}

# Main execution starts here
clear
animate_border
animate_title
animate_border
display_controls

# Define an associative array for app names and their install commands
declare -A apps
apps=(
    ["APPIMAGE-PARSER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/appimage/install.sh | bash"
    ["ARIA2C"]="curl -Ls https://github.com/trashbus99/profork/raw/master/scripts/aria2c.sh | bash"
    ["BATOCERA-CLI/RUN-TO-SEE-ENCLOSED-TOOLS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/docker/cli_install.sh | bash"
    ["DARK-MODE/F1"]="curl -Ls https://github.com/trashbus99/profork/raw/master/dark/dark.sh | bash"
#    ["DECKY/FOR-ARCH-&-FLATPAK-STEAM"]="curl -Ls https://raw.githubusercontent.com/trashbus99/profork/refs/heads/master/scripts/decky.sh | bash"
    ["LIVECAPTIONS/SERVICE"]="curl -Ls https://github.com/trashbus99/profork/raw/master/livecaptions/livecaptions.sh | bash"
    ["MAME0139/v41+/AMD/INTEL/ARM64"]="curl -Ls https://github.com/trashbus99/profork/raw/master/mame2010_v41+/2010.sh | bash"
    ["NVTOP"]="curl -Ls https://github.com/trashbus99/profork/raw/master/nvtop/nvtop.sh | bash"
    ["PS3-PSN-PARSER/ADD-PSN-GAMES-TO-EMULATION-STATION"]="curl -L https://github.com/trashbus99/profork/raw/master/scripts/rpcs3/install.sh | bash"
    ["SUNSHINE-CONTAINER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/sunshine/installer.sh | bash"
    ["SUNSHINE-FLATPAK"]="curl -Ls https://github.com/trashbus99/profork/raw/master/flatpak/install_sunshine.sh | bash"
    ["WINE-CUSTOM-DOWNLOADER/v40+"]="curl -Ls https://github.com/trashbus99/profork/raw/master/wine-custom/wine.sh | bash"
    ["ADD-EMULATOR-CONFIGS-TO-EMULATIONSTATION"]="curl -Ls https://github.com/trashbus99/profork/raw/master/scripts/emgen/emgen.sh | bash"
    ["TESSERACT"]="curl -Ls https://github.com/trashbus99/profork/raw/master/scripts/tesseract.sh | bash"
    ["SYSTEM-SPLASH-VIDEOS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/scripts/logos.sh | bash"
    ["WINE-GE-8-26"]="curl -Ls https://github.com/trashbus99/profork/raw/master/scripts/ge.sh | bash"
    ["XMLSTARLET"]="curl -Ls https://github.com/trashbus99/profork/raw/master/scripts/xmlstarlet.sh | bash"
    ["XDOTOOL"]="curl -Ls https://github.com/trashbus99/profork/raw/master/scripts/xdotool.sh | bash"
    ["ISO-TO-XISO"]="curl -Ls https://github.com/trashbus99/profork/raw/master/scripts/xiso.sh | bash"
    ["ZENITY"]="curl -Ls  https://github.com/trashbus99/profork/raw/master/.dep/.scripts/zenity.sh | bash"
    ["QEMU"]="curl -Ls https://github.com/trashbus99/profork/raw/master/scripts/qemu.sh | bash"
)

# Prepare array for dialog command, sorted by app name
app_list=()
for app in $(printf "%s\n" "${!apps[@]}" | sort); do
    app_list+=("$app" "")
done

# Show dialog menu
cmd=(dialog --menu "Select one application to install or update:" 22 76 16)
choice=$("${cmd[@]}" "${app_list[@]}" 2>&1 >/dev/tty)

# Check if Cancel was pressed
if [ $? -eq 1 ]; then
    echo "Installation cancelled."
    exit
fi

# Install the selected app
run_installation "$choice"
curl -Ls https://github.com/trashbus99/profork/raw/master/app/tools.sh | bash
