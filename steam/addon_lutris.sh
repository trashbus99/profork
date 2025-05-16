#!/bin/bash

# Define the file path
filePath="$HOME/pro/steam/conty.sh"

# Check if the file exists
if [ -f "$filePath" ]; then
    echo "conty.sh exists, continuing the script..."
   
else
    echo "It appears the container is not installed. Please install the multi-app Arch container first, then retry."
    sleep 10
    exit 1
fi


# Display the dialog message box
dialog --title "Lutris Installation Notice" --msgbox "This will install a Lutris system and parser in EmulationStation.\n\nNote: You must create desktop shortcuts in Lutris for the \"+UPDATE SHORTCUTS\" parser to work." 10 50

# User pressed OK, proceed with the script
# Define variables for file paths and URLs
lutris_dir="/userdata/roms/lutris"
update_script_url="https://github.com/trashbus99/profork/raw/master/steam/shortcuts/%2BUPDATE-LUTRIS-SHORTCUTS.sh"
update_script_path="${lutris_dir}/+UPDATE-LUTRIS-SHORTCUTS.sh"
es_config_dir="$HOME/configs/emulationstation"
es_config_url="https://github.com/trashbus99/profork/raw/master/steam/shortcuts/es_configs/es_systems_lutris.cfg"
es_config_path="${es_config_dir}/es_systems_lutris.cfg"

# Create lutris directory if it doesn't exist
if [ ! -d "$lutris_dir" ]; then
    mkdir -p "$lutris_dir"
fi

# Download +UPDATE-LUTRIS-SHORTCUTS.sh and make it executable
curl -L "$update_script_url" -o "$update_script_path"
chmod +x "$update_script_path"

# Download es_systems_lutris.cfg
if [ ! -d "$es_config_dir" ]; then
    mkdir -p "$es_config_dir"
fi
curl -L "$es_config_url" -o "$es_config_path"

wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /userdata/system/configs/emulationstation/es_features_lutris.cfg https://github.com/trashbus99/profork/raw/master/steam/shortcuts/es_configs/es_features_lutris.cfg &
wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /userdata/system/configs/evmapy/Lutris.keys https://github.com/trashbus99/profork/raw/master/steam/shortcuts/es_configs/keys/Lutris.keys &
wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /userdata/system/configs/evmapy/Lutris.keys https://github.com/trashbus99/profork/raw/master/steam/shortcuts/es_configs/keys/lutris.keys &
    wait
        dos2unix /userdata/system/configs/evmapy/*.keys 2>/dev/null

# heroic
if [[ -e /userdata/system/configs/emulationstation/es_systems_heroic2.cfg ]]; then 
    wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /userdata/system/configs/emulationstation/es_systems_heroic2.cfg https://github.com/trashbus99/profork/raw/master/steam/shortcuts/es_configs/es_systems_heroic2.cfg &
    wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /userdata/system/configs/emulationstation/es_features_heroic2.cfg https://github.com/trashbus99/profork/raw/master/steam/shortcuts/es_configs/es_features_heroic2.cfg &
    wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /userdata/system/configs/evmapy/Heroic2.keys https://github.com/trashbus99/profork/raw/master/steam/shortcuts/es_configs/keys/Heroic2.keys &
    wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /userdata/system/configs/evmapy/Heroic2.keys https://github.com/trashbus99/profork/raw/master/steam/shortcuts/es_configs/keys/heroic2.keys &
        wait
            dos2unix /userdata/system/configs/evmapy/*.keys 2>/dev/null
fi 

curl http://127.0.0.1:1234/reloadgames
# Clear dialog (necessary for some terminal environments)
clear
echo "Done"
