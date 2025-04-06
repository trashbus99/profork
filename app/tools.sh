#!/bin/bash

# === BUA Detection ===
if [ -d "/userdata/system/add-ons" ]; then
    rm -f /userdata/roms/ports/Profork.sh
    rm -r /userdata/roms/ports/Profork.sh.keys
    clear
    echo "BUA detected."
    echo "Dual installs not supported"
    echo "Goodbye."
    echo
clear
exit 0
fi




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


# Define an associative array for app names and their install commands
declare -A apps
apps=(
    ["APPIMAGE-PARSER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/appimage/install.sh | bash"
    ["ARIA2C"]="curl -Ls https://github.com/trashbus99/profork/raw/master/scripts/aria2c.sh | bash"
    ["BATOCERA-CLI/RUN-TO-SEE-ENCLOSED-TOOLS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/docker/cli_install.sh | bash"
    ["DARK-MODE/F1"]="curl -Ls https://github.com/trashbus99/profork/raw/master/dark/dark.sh | bash"
#    ["DECKY/FOR-ARCH-&-FLATPAK-STEAM"]="curl -Ls https://raw.githubusercontent.com/trashbus99/profork/refs/heads/master/scripts/decky.sh | bash"
    ["EFIBOOTMGR-EASY-REBOOT-OTHER-OS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/scripts/ei.sh | bash"
    ["LIVECAPTIONS/SERVICE"]="curl -Ls https://github.com/trashbus99/profork/raw/master/livecaptions/livecaptions.sh | bash"
    ["MAME0139/v41+/AMD/INTEL/ARM64"]="curl -Ls https://github.com/trashbus99/profork/raw/master/mame2010_v41+/2010.sh | bash"
    ["NVTOP"]="curl -Ls https://github.com/trashbus99/profork/raw/master/nvtop/nvtop.sh | bash"
    ["PS3-TOOLS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/scripts/ps3a.sh | bash"
    ["SUNSHINE-CONTAINER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/sunshine/installer.sh | bash"
    ["SUNSHINE-FLATPAK"]="curl -Ls https://github.com/trashbus99/profork/raw/master/flatpak/install_sunshine.sh | bash"
    ["WINE-CUSTOM-DOWNLOADER/v40+"]="curl -Ls https://github.com/trashbus99/profork/raw/master/wine-custom/wine.sh | bash"
    ["ADD-EMULATOR-CONFIGS-TO-EMULATIONSTATION"]="curl -Ls https://github.com/trashbus99/profork/raw/master/scripts/emgen/emgen.sh | bash"
    ["TESSERACT"]="curl -Ls https://github.com/trashbus99/profork/raw/master/scripts/tesseract.sh | bash"
    ["PKGX"]="curl -Ls https://github.com/trashbus99/profork/raw/master/scripts/pkgx.sh | bash"
    ["SYSTEM-GAMEBOOT-SPLASH-VIDEOS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/scripts/splash.sh | bash"
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
