#!/usr/bin/env bash

#!/bin/bash

# Get the machine hardware name
architecture=$(uname -m)

# Check if the architecture is x86_64 (AMD/Intel)
if [ "$architecture" != "x86_64" ]; then
    echo "This script only runs on AMD or Intel (x86_64) CPUs, not on $architecture."
    exit 1
fi

# GPU Compatibility Warning
dialog --title "Steam Mini container GPU Compatibility Warning" \
       --yesno "⚠️  Only AMD and Intel GPUs are supported.\n\n❌ NVIDIA is NOT supported.\n\nDownload the multi-app container for NVIDIA support.\n\nDo you want to continue?" 15 50

# Check user's response
response=$?
if [ $response -ne 0 ]; then
    clear
    echo "Installation aborted by the user."
    exit 1
fi


MESSAGE="This container is compatible with EXT4 or BTRFS partitions only!  FAT32/NTFS/exFAT are not supported.  Continue?"

# Use dialog to create a yes/no box
if dialog --title "Compatibility Warning" --yesno "$MESSAGE" 10 70; then
    # If the user chooses 'Yes', continue the installation
    echo "Continuing installation..."
    # Add your installation commands here
else
    # If the user chooses 'No', exit the script
    echo "Installation aborted by user."
    exit 1
fi


MESSAGE="WARNING: Batocera's Custom SDL/kernel mods break XINPUT over BLUETOOTH on apps in the Arch container. Xbox One/S/X controllers are verified working via wired USB or the Xbox wireless adapter only. 8bitDO controller users can switch their input mode to d-input or switch input.  Continue?"

# Use dialog to create a yes/no box
if dialog --title "Compatibility Warning" --yesno "$MESSAGE" 10 70; then
    # If the user chooses 'Yes', continue the installation
    echo "Continuing installation..."
    # Add your installation commands here
else
    # If the user chooses 'No', exit the script
    echo "Installation aborted by user."
    exit 1
fi

MESSAGE="INFO: There is no separate Steam menu for steam games in emulationstation on the mini build.  Continue?"

# Use dialog to create a yes/no box
if dialog --title "Menu Info" --yesno "$MESSAGE" 10 70; then
    # If the user chooses 'Yes', continue the installation
    echo "Continuing installation..."
    # Add your installation commands here
else
    # If the user chooses 'No', exit the script
    echo "Installation aborted by user."
    exit 1
fi

# Clear the screen after the dialog is closed
clear

######################################################################
# Steam Installer Script
######################################################################

# Define Colors
RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
BLUE='\033[1;34m'
MAGENTA='\033[1;35m'
CYAN='\033[1;36m'
WHITE='\033[1;37m'
RESET='\033[0m'

# Clear the screen
clear

# Banner
echo -e "${MAGENTA}##########################################################${RESET}"
echo -e "${CYAN}               PROFORK ${RED}STEAM INSTALLER${RESET}${CYAN}               ${RESET}"
echo -e "${MAGENTA}##########################################################${RESET}"
sleep 1

# Display Installation Information
echo -e "${YELLOW}"
echo -e "**********************************************************"
echo -e "* ${GREEN}This will install Steam to F1 -> Applications.${YELLOW}         *"
echo -e "* ${GREEN}An additional launcher will also be added to Ports.${YELLOW}    *"
echo -e "* ${RED}Please wait...${YELLOW}                                         *"
echo -e "**********************************************************"
echo -e "${RESET}"

# Show progress with animation
for i in {1..3}; do
    echo -ne "${CYAN}Steam Container made with Conty from Kron4ek"
    for j in {1..3}; do
        echo -ne "."
        sleep 0.5
    done
    echo -ne "${RESET}\r"
done

# End of Info Script
echo -e ""
echo -e "Steam will be installed to /userdata/system/pro/steam"
sleep 1
echo -e "${GREEN}Starting the installation process now...${RESET}"
sleep 1





######################################################################
# PROFORK INSTALLER
######################################################################
# --------------------------------------------------------------------
APPNAME=STEAM # for installer info
appname=steam # directory name in /userdata/system/pro/...
AppName=steam.sh # Shell script name
APPPATH=/userdata/system/pro/$appname
APPLINK=https://github.com/trashbus99/profork/releases/download/r1/steam.sh
ORIGIN="PROFORK" # credit & info
# --------------------------------------------------------------------
# Output colors:
X='\033[0m' # reset color
GREEN='\033[1;32m'
# --------------------------------------------------------------------
# Prepare paths and files for installation 
pro=/userdata/system/pro
mkdir -p $pro/extra $pro/$appname/extra

# Clean up and prepare installer
killall wget 2>/dev/null && killall $AppName 2>/dev/null
rm -rf /userdata/system/pro/$appname/extra/downloads
mkdir /userdata/system/pro/$appname/extra/downloads

# Download and prepare the main application
temp=/userdata/system/pro/$appname/extra/downloads
echo
echo -e "${GREEN}DOWNLOADING $APPNAME . . .${X}"
sleep 1
cd $temp
curl --progress-bar --remote-name --location "$APPLINK"
mv $temp/* $APPPATH 2>/dev/null
chmod +x $APPPATH/steam.sh
rm -rf $temp
echo -e "${GREEN}> DONE${X}"

# Install launcher script
launcher=/userdata/system/pro/$appname/Launcher
rm -rf $launcher
echo '#!/bin/bash ' >> $launcher
echo 'export DISPLAY=:0.0; unclutter-remote -s' >> $launcher
echo 'ulimit -H -n 819200 && ulimit -S -n 819200 && sysctl -w fs.inotify.max_user_watches=8192000 vm.max_map_count=2147483642 fs.file-max=8192000 >/dev/null 2>&1 && ALLOW_ROOT=1 dbus-run-session /userdata/system/pro/steam/steam.sh steam' >> $launcher
chmod +x $launcher
cp $launcher /userdata/roms/ports/$appname.sh 2>/dev/null


# Install desktop shortcut
icon=/userdata/system/pro/$appname/extra/icon.png
mkdir -p /userdata/system/pro/$appname/extra
wget --tries=3 --timeout=10 --no-check-certificate -q -O $icon https://github.com/trashbus99/profork/raw/master/steam/extra/icon.png

shortcut=/userdata/system/pro/$appname/extra/$appname.desktop
rm -rf $shortcut
echo "[Desktop Entry]" >> $shortcut
echo "Version=1.0" >> $shortcut
echo "Icon=/userdata/system/pro/$appname/extra/icon.png" >> $shortcut
echo "Exec=/userdata/system/pro/$appname/Launcher %U" >> $shortcut
echo "Terminal=false" >> $shortcut
echo "Type=Application" >> $shortcut
echo "Categories=Game;batocera.linux;" >> $shortcut
echo "Name=$appname" >> $shortcut
cp $shortcut /usr/share/applications/$appname.desktop 2>/dev/null


# Prepare prelauncher to avoid overlay
pre=/userdata/system/pro/$appname/extra/startup
rm -rf $pre
echo "#!/usr/bin/env bash" >> $pre
echo "cp /userdata/system/pro/$appname/extra/$appname.desktop /usr/share/applications/ 2>/dev/null" >> $pre
chmod +x $pre

# Add prelauncher to custom.sh
customsh=/userdata/system/custom.sh
if ! grep -q "/userdata/system/pro/$appname/extra/startup" $customsh; then
    echo -e "\n/userdata/system/pro/$appname/extra/startup" >> $customsh
fi
chmod +x $customsh

echo "DONE! -- Update Gamelists to see addition in ports"
sleep 5
echo "Exiting.."
sleep 2
