#!/bin/bash

clear 

# Function to display animated title with colors
animate_title() {
    local text="Linux & Windows/Wine Freeware games"
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
    ["Celeste-Classic/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/celeste.sh | bash" 
    ["Celeste-64/LINUX"]="curl -Ls https://github.com/trashbus99/profork/raw/master/celeste64/c64.sh | bash"
    ["Apotris/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/apotris.sh | bash"
    ["Maldita-Castilla/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/maldita_castilla.sh | bash"
    ["Spelunky-Classic/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/spelunky.sh | bash"
    ["Donkey-Kong-Advanced/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/dka.sh | bash"
    ["Portaboy/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/portaboy.sh | bash"
    ["Teather-N-Feather/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/tnf.sh | bash"
    ["The-Ur-Quan-Masters/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/uqm.sh | bash"       
    ["MEGAMAN-X8-16-BIT-DEMAKE/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/megamanx8.sh | bash"
    ["SHEEPY-A-SHORT-ADVENTURE/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/sheepy.sh | bash"
    ["SPACE-QUEST-3D/SQ3-REMAKE/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/sq3d.sh | bash"
    ["STARFIGHTER-MOVIE-ARCADE-GAME/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/starfighter.sh | bash"
    ["STRATOSPEAR-JAM/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/sj.sh | bash"
    ["OPENRA-CNC-TIBERIAN-DAWN/LINUX"]="curl -Ls https://github.com/trashbus99/profork/raw/master/openra/td.sh | bash"
    ["OPENRA-CNC-RED-ALERT/LINUX"]="curl -Ls https://github.com/trashbus99/profork/raw/master/openra/ra.sh | bash"
    ["OPENRA-DUNE-2000/LINUX"]="curl -Ls https://github.com/trashbus99/profork/raw/master/openra/d2k.sh | bash"
    ["ENDLESS-SKY/LINUX"]="curl -Ls https://github.com/trashbus99/profork/raw/master/endlesssky/endlesssky.sh | bash"
    ["AM2R/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/a2r.sh | bash"
    ["Z2-ADV-OF-LNK-Remake/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/z2r.sh | bash"
    ["TLOZ-DUNGEONS-OF-INFINITY/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/doi.sh | bash"
    ["HYDORA/CONTAINER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/hydorah/hydorah.sh | bash"
    ["CRASH-BANDICOOT-BACK-IN-TIME/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/cbit.sh | bash"
    ["MODERN-MODERN-CHEF/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/mmc.sh | bash"
    ["SONIC-TRIPLE-TROUBLE/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/stt.sh | bash"
    ["TMNT-RESCUE-PALOOZA/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/tmntrp | bash"
    ["MEGA-MAN-AGAIN/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/mma.sh | bash"
    ["STREET-FIGHTER-X-MEGA-MAN/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/sfxmm.sh | bash"
    ["SONIC-AND-THE-FALLEN-STAR/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/safs.sh | bash"
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
echo "refresh gamelist after instalation"
