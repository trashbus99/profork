#!/bin/bash

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
OPTIONS=("1" "Install Portmaster"
         "2" "Install Librewolf Web Browser (XWAYLAND)"
         "3" "Install Aethersx2 (For Qualcomm SoCs -- RK3588 like OPI5 should Use Rocknix)"
         "4" "Restore Mame .0139 to v41+"         
         "5" "Youtube TV UI (XWAYLAND)"
         "6" "Youtube Music (XWAYLAND)"
         "7" "X-Minecraft Launcher (XWAYLAND - EXPERIMENTAL)"
         "8" "Chiaki-NG (XWAYLAND)"
         "99" "Exit")
         
# Display the dialog and get the user choice
CHOICE=$(dialog --clear --backtitle "Profork Main Menu" \
                --title "Main Menu" \
                --menu "Choose an option:" 15 120 3 \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear

# Act based on the user choice
case $CHOICE in
    1)
        echo "Portmaster Installer..."
        curl -Ls https://github.com/trashbus99/profork/raw/master/portmaster/install.sh | bash
        ;;
    2)
        echo "Librewolf Web Browser Installer..."
        curl -Ls https://github.com/trashbus99/profork/raw/master/librewolf/install_arm64.sh | bash
        ;;   
    3)
        echo "AetherSX2 Experimental..."
        curl -Ls https://raw.githubusercontent.com/trashbus99/profork/refs/heads/master/aethersx2/aethersx2.sh | bash
        ;;    
    4)
        echo "Mame 0139 for v41+..."
        curl -Ls https://github.com/trashbus99/profork/raw/master/mame2010_v41%2B/2010_arm64.sh | bash
        ;;                
    5)
        echo "Youtube on TV..."
        curl -Ls  https://github.com/trashbus99/profork/raw/master/youtubetv/yttv-arm64.sh | bash
        ;;   
    6)
        echo "Youtube Music..."
        curl -Ls https://github.com/trashbus99/profork/raw/master/youtube-music/ytm-arm64.sh | bash     
        ;;
    7)
        echo "X-Minecraft-Launcher..."
        curl -Ls  https://github.com/trashbus99/profork/raw/master/xmcl/xmcl-arm64.sh | bash
        ;;   
    8)
        echo "Chiaki-NG..."
        curl -Ls https://github.com/trashbus99/profork/raw/master/chiaki/chiaki-arm64.sh | bash
        ;;

    98)
       echo "Pop-Quiz...loading.."
       curl -Ls https://github.com/trashbus99/profork/raw/master/app/pq.sh | bash
        ;;
    
    99)
        echo "Exiting..."
           exit
        ;;
    *)
        echo "No valid option selected or cancelled. Exiting."
        ;;
esac
