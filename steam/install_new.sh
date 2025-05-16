#!/bin/bash

# Get the machine hardware name
architecture=$(uname -m)

# Check if the architecture is x86_64 (AMD/Intel)
if [ "$architecture" != "x86_64" ]; then
    echo "This script only runs on AMD or Intel (x86_64) CPUs, not on $architecture."
    exit 1
fi

clear 

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

# Clear the screen after the dialog is closed
clear

# Function to show dialog confirmation box
confirm_start() {
    # Ensure dialog is installed
    if ! command -v dialog &> /dev/null; then
        echo "The 'dialog' utility is not installed. Please install it to continue."
        exit 1
    fi

    dialog --title "Confirm Operation" --yesno "This process may take a long time. 45-90 minutes is typical depending on Internet, Cpu and Drive Speed. If a mirror fails and it gets stuck in a loop, try again in serveral hours.  Do you want to proceed?" 15 70
    local status=$?
    clear # Clear dialog remnants from the screen
    return $status
}

# Initial message
clear
animate_text "Container Builder/Updater"

# Show confirmation dialog box
if ! confirm_start; then
    echo "Operation aborted by the user."
    exit 1
fi

# Minimum required free space in KB (30GB)
MIN_FREE_SPACE=$((30*1024*1024))

# Check free space on the root partition, ensuring we're getting just the available space in 1K blocks
FREE_SPACE=$(df --output=avail / | tail -n 1)

# Convert to KB (Note: `df` output in 1K blocks is already in KB, so no conversion is necessary)
FREE_SPACE_KB=$FREE_SPACE

# Check if free space is less than the minimum required
if [ $FREE_SPACE_KB -lt $MIN_FREE_SPACE ]; then
    # Warning message using dialog, asking if they want to proceed
    dialog --title "Warning" --yesno "At least 30GB of temporary free space is recommended for building. The final container size is ~5-6gb. Proceed?" 10 50
    
    response=$?
    clear # Clear dialog artifacts from terminal
    if [ $response -eq 0 ]; then
        echo "User chose to proceed."
        # Place the rest of your script here that should run if the user chooses to proceed.
    else
        echo "User chose not to proceed. Exiting."
        exit 1
    fi
else
    echo "Sufficient disk space available. Continuing..."
    # Place the rest of your script here that should run if there is enough space.
fi
clear


# Define colors
BLUE="\033[1;34m"
WHITE="\033[1;37m"
NC="\033[0m" # No Color

# Function to print the ASCII logo and the text in blue
print_blue() {
    echo -e "${BLUE}       /\\"
    echo -e "      /  \\"
    echo -e "     /\\   \\"
    echo -e "    /      \\"
    echo -e "   /   ,,   \\"
    echo -e "  /   |  |  -\\"
    echo -e " /_-''    ''-_\\${NC}"
    echo -e "${BLUE}ARCH LINUX CONTAINER INSTALLER.\nTHANKS TO KRON4EK${NC}"
}

# Function to print the ASCII logo and the text in white
print_white() {
    echo -e "${WHITE}       /\\"
    echo -e "      /  \\"
    echo -e "     /\\   \\"
    echo -e "    /      \\"
    echo -e "   /   ,,   \\"
    echo -e "  /   |  |  -\\"
    echo -e " /_-''    ''-_\\${NC}"
    echo -e "${WHITE}ARCH LINUX CONTAINER INSTALLER.\nTHANKS TO UUREEL${NC}"
}

# Clear the screen
clear

# Animation loop
for i in {1..10}; do
    print_blue
    sleep 0.5 # wait for 0.5 seconds
    clear
    print_white
    sleep 0.5 # wait for 0.5 seconds
    clear
done


# Function to display animated title
animate_title() {
    local text="Arch container installer"
    local delay=0.1
    local length=${#text}

    for (( i=0; i<length; i++ )); do
        echo -n "${text:i:1}"
        sleep $delay
    done
    echo
}

display_controls() {
    echo 
    echo "This Will install Steam, Heroic-Games Launcher, Lutris,"
    echo "and more apps in an Arch container with"
    echo "a new system appearing in ES called Arch Container or"
    echo "Linux depending on your theme in ~/pro/steam"  
    echo "This will take a while"
    sleep 10  # Delay for 10 seconds
}

clear


#make rom folder
clear
echo "Creating ROM Folder in /userdata/rom/conty"
github_url="https://github.com/trashbus99/profork/raw/master/steam/shortcuts/"
target_directory="/userdata/roms/conty/"
sleep 3

# Create the target directory if it doesn't exist
mkdir -p "$target_directory"

# Remove old .sh files
for file in "${old_sh_files[@]}"; do
  rm "${target_directory}${file}" 2>/dev/null
done



sleep 3

# Step 7: Make /userdata/roms/steam2 folder if it doesn't exist and download parser

# Define variables
FILE_URL="https://github.com/trashbus99/profork/raw/master/steam/shortcuts/%23%23UPDATE-STEAM-SHORTCUTS%23%23"
DOWNLOAD_DIR="/userdata/roms/steam2"
SCRIPT_NAME="##UPDATE-STEAM-SHORTCUTS##"

# Create directory if it doesn't exist
mkdir -p "$DOWNLOAD_DIR"

# Download the file
clear
echo "Downloading Parser"
rm /userdata/roms/steam2/+UPDATE-STEAM-SHORTCUTS.* 2>/dev/null
wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O "/userdata/roms/steam2/+UPDATE-STEAM-SHORTCUTS.sh" https://github.com/trashbus99/profork/raw/master/steam/shortcuts/%2BUPDATE-STEAM-SHORTCUTS.sh
chmod +x /userdata/roms/steam2/+UPDATE-STEAM-SHORTCUTS.sh

# Make the script executable
chmod +x "$DOWNLOAD_DIR/$SCRIPT_NAME"

# Step 8: Download ES custom Steam2 & conty/Arch system .cfgs to ~/configs/emulationstation
clear
echo "Downloading ES Systems"
    wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /userdata/system/configs/emulationstation/es_systems_arch.cfg https://github.com/trashbus99/profork/raw/master/steam/shortcuts/es_configs/es_systems_arch.cfg &
    wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /userdata/system/configs/emulationstation/es_features_arch.cfg https://github.com/trashbus99/profork/raw/master/steam/shortcuts/es_configs/es_features_arch.cfg &
    wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /userdata/system/configs/emulationstation/es_systems_steam2.cfg https://github.com/trashbus99/profork/raw/master/steam/shortcuts/es_configs/es_systems_steam2.cfg &
    wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /userdata/system/configs/emulationstation/es_features_steam2.cfg https://github.com/trashbus99/profork/raw/master/steam/shortcuts/es_configs/es_features_steam2.cfg &
    #
   # wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /userdata/system/configs/evmapy/Arch.keys https://github.com/trashbus99/profork/raw/master/steam/shortcuts/es_configs/keys/Arch.keys &
   # wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /userdata/system/configs/evmapy/Lutris.keys https://github.com/trashbus99/profork/raw/master/steam/shortcuts/es_configs/keys/Lutris.keys &
   # wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /userdata/system/configs/evmapy/Lutris.keys https://github.com/trashbus99/profork/raw/master/steam/shortcuts/es_configs/keys/lutris.keys &
   # wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /userdata/system/configs/evmapy/Heroic2.keys https://github.com/trashbus99/profork/raw/master/steam/shortcuts/es_configs/keys/Heroic2.keys &
   # wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /userdata/system/configs/evmapy/Heroic2.keys https://github.com/trashbus99/profork/raw/master/steam/shortcuts/es_configs/keys/heroic2.keys &
   # wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /userdata/system/configs/evmapy/steam2.keys https://github.com/trashbus99/profork/raw/master/steam/shortcuts/es_configs/keys/steam2.keys &
   # wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /userdata/system/configs/evmapy/steam.keys https://github.com/trashbus99/profork/raw/master/steam/shortcuts/es_configs/keys/steam.keys &
    #
    wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /userdata/system/pro/steam/batocera-conty-patcher.sh https://github.com/trashbus99/profork/raw/master/steam/build/batocera-conty-patcher.sh &
        wait
            dos2unix /userdata/system/configs/evmapy/*.keys 2>/dev/null
            dos2unix /userdata/system/pro/steam/batocera-conty-patcher.sh 2>/dev/null
                chmod 777 /userdata/system/pro/steam/batocera-conty-patcher.sh 2>/dev/null

# lutris
if [[ -e /userdata/system/configs/emulationstation/es_systems_lutris.cfg ]]; then 
    wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /userdata/system/configs/emulationstation/es_systems_lutris.cfg https://github.com/trashbus99/profork/raw/master/steam/shortcuts/es_configs/es_systems_lutris.cfg &
    wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /userdata/system/configs/emulationstation/es_features_lutris.cfg https://github.com/trashbus99/profork/raw/master/steam/shortcuts/es_configs/es_features_lutris.cfg &
    wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /userdata/system/configs/evmapy/Lutris.keys https://github.com/trashbus99/profork/raw/master/steam/shortcuts/es_configs/keys/Lutris.keys &
    wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /userdata/system/configs/evmapy/Lutris.keys https://github.com/trashbus99/profork/raw/master/steam/shortcuts/es_configs/keys/lutris.keys &
        wait
            dos2unix /userdata/system/configs/evmapy/*.keys 2>/dev/null
fi

# heroic
if [[ -e /userdata/system/configs/emulationstation/es_systems_heroic2.cfg ]]; then 
    wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /userdata/system/configs/emulationstation/es_systems_heroic2.cfg https://github.com/trashbus99/profork/raw/master/steam/shortcuts/es_configs/es_systems_heroic2.cfg &
    wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /userdata/system/configs/emulationstation/es_features_heroic2.cfg https://github.com/trashbus99/profork/raw/master/steam/shortcuts/es_configs/es_features_heroic2.cfg &
    wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /userdata/system/configs/evmapy/Heroic2.keys https://github.com/trashbus99/profork/raw/master/steam/shortcuts/es_configs/keys/Heroic2.keys &
    wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /userdata/system/configs/evmapy/Heroic2.keys https://github.com/trashbus99/profork/raw/master/steam/shortcuts/es_configs/keys/heroic2.keys &
        wait
            dos2unix /userdata/system/configs/evmapy/*.keys 2>/dev/null
fi 

clear

echo "Launching container builder script -- This will take a while"
sleep 5

curl -Ls  https://github.com/trashbus99/profork/raw/master/steam/build.sh | bash 

MSG="Install Done. Update Gamelist to see new system(s). You should see a new system in EmulationStation called Linux or Arch Container depending on theme.\n\nMore apps available in PCMAN-Filemanager"
dialog --title "Arch Container Setup Complete" --msgbox "$MSG" 20 70

curl -L https://github.com/trashbus99/profork/raw/master/app/mainmenu.sh | bash

