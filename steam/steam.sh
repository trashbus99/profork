#!/bin/bash


# Part 1: Display initial message
dialog --msgbox "Note for Steam: the official flatpak version of Steam is now working on v40.  Data is stored in /userdata/saves/flatpak/data/.var/app/com.valvesoftware.Steam/data/Steam \n\nRegular Proton builds have been verified working and the flatpak build is a smaller install.\n\nThe Arch container build supports xdg and launching Heroic, Lutris, and other games via Steam plus tools like protontricks and protonup-qt are included. \n\nthe Arch container stores steam data in ~/.local/share/Steam and the container size is around 5GB." 20 70

# Get the machine hardware name
architecture=$(uname -m)

# Check if the architecture is x86_64 (AMD/Intel)
if [ "$architecture" != "x86_64" ]; then
    echo "This script only runs on AMD or Intel (x86_64) CPUs, not on $architecture."
    exit 1
fi



# Define the options
OPTIONS=("1" "Install/Update Rolling Arch release/Build from scratch "
         "2" "Install Flatpak Steam" 
         "3" "List all Packages in Container"
         "4" "Uninstall Arch Container"
         "5" "Update ES Launcher shortcuts for Arch container"
         "6" "Addon: Decky Support"
         "7" "Addon: XFCE/MATE/LXDE DESKTOP Mode"
         "8" "Addon: Add/Update Lutris Menu & Shortcuts to Emulationstation"
         "9" "Addon: Add/Update Heroic Menu & Shortcuts to Emulationstation"
         "10" "Addon: Add/Update PS4 Menu and Shortcuts to Emulationstation"
         "11" "Addon: Emudeck (experimental)"
         "12" "Addon: Nativefier (turn websites into apps and add to ES Menu)")

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
        echo "Installing Steam Container..."
        rm /tmp/runner 2>/dev/null
        wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /tmp/runner https://github.com/trashbus99/profork/raw/master/steam/install_new.sh
        dos2unix /tmp/runner 2>/dev/null 
        chmod 777 /tmp/runner 2>/dev/null
        bash /tmp/runner
        ;;
     2)
     echo "Installing flatpak steam"
     clear
     flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo && flatpak install --system -y com.valvesoftware.Steam
     clear
     echo "Refresh game list and you should see steam in the system menu"
       ;;  
     3)
        echo "Loading Package List..."
        rm /tmp/runner 2>/dev/null
        wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /tmp/runner https://github.com/trashbus99/profork/raw/master/steam/list.sh
        dos2unix /tmp/runner 2>/dev/null 
        chmod 777 /tmp/runner 2>/dev/null
        bash /tmp/runner
        ;;
    4)
        echo "Loading Uninstall script..."
        rm /tmp/runner 2>/dev/null
        wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /tmp/runner https://github.com/trashbus99/profork/raw/master/steam/uninstall.sh
        dos2unix /tmp/runner 2>/dev/null 
        chmod 777 /tmp/runner 2>/dev/null
        bash /tmp/runner
        ;;
    5)  
        echo "Update EmulationStation Arch Container Launcher Shortcuts..."
        rm /tmp/runner 2>/dev/null
        wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /tmp/runner https://github.com/trashbus99/profork/raw/master/steam/update_shortcuts.sh
        dos2unix /tmp/runner 2>/dev/null 
        chmod 777 /tmp/runner 2>/dev/null
        bash /tmp/runner
        ;;    
    6)  
        echo "Add Decky Support..."
        rm /tmp/runner 2>/dev/null
        wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /tmp/runner https://github.com/trashbus99/profork/raw/master/scripts/decky.sh
        dos2unix /tmp/runner 2>/dev/null 
        chmod 777 /tmp/runner 2>/dev/null
        bash /tmp/runner
        ;;
     7)  
        echo "Installing Desktop/Windowed Mode..."
        rm /tmp/runner 2>/dev/null
        wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /tmp/runner https://github.com/trashbus99/profork/raw/master/steam/arch-de.sh
        dos2unix /tmp/runner 2>/dev/null 
        chmod 777 /tmp/runner 2>/dev/null
        bash /tmp/runner
        ;;
    8)  
        echo "Add/Update Lutris shortcuts to emulationstation..."
        rm /tmp/runner 2>/dev/null
        wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /tmp/runner https://github.com/trashbus99/profork/raw/master/steam/addon_lutris.sh
        dos2unix /tmp/runner 2>/dev/null 
        chmod 777 /tmp/runner 2>/dev/null
        bash /tmp/runner
        ;;
    9)  
        echo "Add/update Heroic shortcuts to emulationstation..."
        rm /tmp/runner 2>/dev/null
        wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /tmp/runner https://github.com/trashbus99/profork/raw/master/steam/addon_heroic.sh
        dos2unix /tmp/runner 2>/dev/null 
        chmod 777 /tmp/runner 2>/dev/null
        bash /tmp/runner
        ;;
  10)  
        echo "Add/update PS4 shortcuts to emulationstation..."
        rm /tmp/runner 2>/dev/null
        wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /tmp/runner https://github.com/trashbus99/profork/raw/master/steam/addon_ps4.sh
        dos2unix /tmp/runner 2>/dev/null 
        chmod 777 /tmp/runner 2>/dev/null
        bash /tmp/runner
        ;;
 11)  
        echo "Emudeck Menu..."
        rm /tmp/runner 2>/dev/null
        wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /tmp/runner https://github.com/trashbus99/profork/raw/master/emudeck/emudeck.sh
        dos2unix /tmp/runner 2>/dev/null 
        chmod 777 /tmp/runner 2>/dev/null
        bash /tmp/runner
        ;;
    12)  
        echo "Webapps Installer..."
        rm /tmp/runner 2>/dev/null
        wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /tmp/runner https://github.com/trashbus99/profork/raw/master/webapps/install.sh
        dos2unix /tmp/runner 2>/dev/null 
        chmod 777 /tmp/runner 2>/dev/null
        bash /tmp/runner
        ;;
    12)  
        echo "NVIDIA CUDA Installer..."
        rm /tmp/runner 2>/dev/null
        wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /tmp/runner https://github.com/trashbus99/profork/raw/master/steam/build/cuda.sh
        dos2unix /tmp/runner 2>/dev/null 
        chmod 777 /tmp/runner 2>/dev/null
        bash /tmp/runner
        ;;
    *)
        echo "No valid option selected or cancelled. Exiting."
        ;;
esac
