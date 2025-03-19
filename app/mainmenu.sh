#!/bin/bash

# Detect system architecture
ARCH=$(uname -m)

# If the system is ARM64 (aarch64), execute the ARM script
if [ "$ARCH" = "aarch64" ]; then
    echo "ARM64 (aarch64) detected. Loading ARM Menu..."
    sleep 2
    curl -Ls https://github.com/trashbus99/profork/raw/master/app/arm_menu.sh | bash
    exit 0
fi

# If the system is x86_64, continue with the normal setup
if [ "$ARCH" != "x86_64" ]; then
    echo "This script only runs on x86_64 (AMD/Intel) or aarch64 (ARM64)."
    exit 1
fi
echo "x86_64 (AMD/INTEL) detected. Loading Main Menu....."
sleep 2

# Colors for animation
RED='\e[0;31m'
YELLOW='\e[1;33m'
NC='\e[0m' # No Color

# Function to display animated text faster
animate_text() {
    local text="$1"
    echo -e "$text"
    sleep 0.
}

clear

# Display Warning Message
animate_text "${YELLOW}⚠️  Important Notice ⚠️${NC}"
animate_text "${YELLOW}The apps on this repository are provided AS-IS.${NC}"

animate_text "${RED}DO NOT ask for help in the Batocera Discord.${NC}"
animate_text "${RED}They will NOT help you and will REFUSE support if they are made aware unofficial apps are installed.${NC}"

animate_text "${YELLOW}Use at your own risk.${NC}"

# Reset color
echo -e "${NC}"



sleep 10

# Define the options
OPTIONS=("1" "Arch Container (Steam, Heroic, Lutris & More apps)"
         "2" "Standalone Apps (mostly appimages)"
         "3" "Docker & Containers"
         "4" "Tools"
         "5" "Wine Custom Downloader v40+"
         "6" "Flatpak Linux Games"
         "7" "Other Linux & Windows/Wine Freeware games"
         "8" "Install Portmaster"
         "9" "Install This Menu to Ports"              
         "10" "Exit")
         
# Display the dialog and get the user choice
CHOICE=$(dialog --clear --backtitle "Profork Main Menu" \
                --title "Main Menu" \
                --menu "Choose an option:" 15 80 3 \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear

# Act based on the user choice
case $CHOICE in
    1)
        echo "Arch Container..."
        curl -Ls https://github.com/trashbus99/profork/raw/master/steam/steam.sh | bash
        ;;
    2)
        echo "Apps Menu"
        rm /tmp/runner 2>/dev/null
        wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /tmp/runner https://github.com/trashbus99/profork/raw/master/app/appmenu.sh
        dos2unix /tmp/runner 2>/dev/null 
        chmod 777 /tmp/runner 2>/dev/null
        bash /tmp/runner
        ;;
    3)
        echo "Docker Menu..."
        rm /tmp/runner 2>/dev/null
        wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /tmp/runner https://github.com/trashbus99/profork/raw/master/app/dockermenu.sh
        dos2unix /tmp/runner 2>/dev/null 
        chmod 777 /tmp/runner 2>/dev/null
        bash /tmp/runner
        ;;
    4)
        echo "Tools Menu..."
        rm /tmp/runner 2>/dev/null
        wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /tmp/runner https://github.com/trashbus99/profork/raw/master/app/tools.sh
        chmod 777 /tmp/runner 2>/dev/null
        bash /tmp/runner
        ;;
    5)  echo "Wine Custom...."
        curl -Ls https://github.com/trashbus99/profork/raw/master/wine-custom/wine.sh | bash
        ;;              
    6)  echo "Flatpak Linux Games..."
        curl -Ls https://github.com/trashbus99/profork/raw/master/app/fgs.sh | bash
        ;;            
    7)  echo "Other Linux & Windows/Wine Freeware..."
        curl -Ls https://github.com/trashbus99/profork/raw/master/app/wquashfs.sh | bash
        ;;             
    8)  echo "Portmaster Installer..."
        curl -Ls https://github.com/trashbus99/profork/raw/master/portmaster/install.sh | bash
        ;;
    9)  echo "Ports Installer..."
        rm /tmp/runner 2>/dev/null
        wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /tmp/runner https://github.com/trashbus99/profork/raw/master/app/install.sh
        chmod 777 /tmp/runner 2>/dev/null
        bash /tmp/runner
        ;;
    10)
        echo "Exiting..."
           exit
        ;;
    *)
        echo "No valid option selected or cancelled. Exiting."
        ;;
esac
