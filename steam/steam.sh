#!/bin/bash


# === BUA Detection ===
if [ -d "/userdata/system/add-ons" ]; then
    clear
    echo "BUA detected."
    echo "Dual installs not supported"
    echo "Goodbye."
    echo
    exit 0
fi
clear 

# Get the machine hardware name
architecture=$(uname -m)

# Check if the architecture is x86_64 (AMD/Intel)
if [ "$architecture" != "x86_64" ]; then
    echo "This script only runs on AMD or Intel (x86_64) CPUs, not on $architecture."
    exit 1
fi



# Define the options
OPTIONS=("1" "Install/Update Arch Container "
         "2" "List all Packages in Multi-App Container"
         "3" "Uninstall Arch Container"
         "4" "Update ES Launcher shortcuts for Arch container"
         "5" "Addon: XFCE/MATE/LXDE DESKTOP Mode"
         "6" "Addon: Add/Update Lutris Menu & Shortcuts to Emulationstation"
         "7" "Addon: Add/Update Heroic Menu & Shortcuts to Emulationstation"
         "8" "Addon: Add/Update PS4 Menu & Shortcuts to Emulationstation"
         "9" "Addon: Emudeck"
         "10" "Addon: Webapps"
         "99" "Exit to main menu")
while true; do
# Display the dialog and get the user choice
CHOICE=$(dialog --clear --backtitle "Arch Container Management" \
                --title "Main Menu" \
                --menu "Choose an option:" 22 90 5 \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear

# Act based on the user choice
case $CHOICE in
     1)
        echo "Installing Arch Container..."
        curl -Ls https://github.com/trashbus99/profork/raw/master/steam/install2.sh | bash
        ;;
     2)
        echo "Loading Package List..."
        curl -Ls https://github.com/trashbus99/profork/raw/master/steam/list.sh | bash
       ;;
    3)
        echo "Loading Uninstall script..."
        curl -Ls https://github.com/trashbus99/profork/raw/master/steam/uninstall.sh | bash
        ;;
    4)  
        echo "Update EmulationStation Arch Container Launcher Shortcuts..." 
        curl -Ls https://github.com/trashbus99/profork/raw/master/steam/update_shortcuts.sh | bash
        ;;    
     5)  
        echo "Installing Desktop/Windowed Mode..."
        curl -Ls https://github.com/trashbus99/profork/raw/master/steam/arch-de.sh | bash
        ;;
    6)  
        echo "Add/Update Lutris shortcuts to emulationstation..."
        curl -Ls https://github.com/trashbus99/profork/raw/master/steam/addon_lutris.sh | bash
        ;;
    7)  
        echo "Add/update Heroic shortcuts to emulationstation..."
        rm /tmp/runner 2>/dev/null
        curl -Ls  https://github.com/trashbus99/profork/raw/master/steam/addon_heroic.sh | bash
        ;;
   8)  
        echo "Add/update PS4 shortcuts to emulationstation..."
        curl -Ls http://github.com/trashbus99/profork/raw/master/steam/addon_ps4.sh | bash
        ;;
  9)  
        echo "Emudeck Menu..."
        rm /tmp/runner 2>/dev/null
        curl -Ls https://github.com/trashbus99/profork/raw/master/emudeck/emudeck.sh | bash
        ;;
 10)  
        echo "Webapps Installer..."
        curl -Ls https://github.com/trashbus99/profork/raw/master/webapps/install.sh | bash
        ;;
 99)
        echo "Exiting..."
        exit
        ;;
    
    *)
        echo "No valid option selected or cancelled. Exiting."
        ;;
esac
   done
