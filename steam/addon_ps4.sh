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
dialog --title "PS4 (SHADPS4) Notice" --msgbox "This will install a PS4 system and parser in EmulationStation.\n\nNote: You must Select 'add shortcut' for each game in SHADPS4 for the \"+UPDATE PS4 SHORTCUTS\" parser to work." 10 60

# User pressed OK, proceed with the script
# Define variables for file paths and URLs
ps4_dir="/userdata/roms/ps4"
update_script_url="https://github.com/trashbus99/profork/raw/master/steam/shortcuts/%2BUPDATE-PS4-SHORTCUTS.sh"
update_script_path="${ps4_dir}/+UPDATE-PS4-SHORTCUTS.sh"
es_config_dir="$HOME/configs/emulationstation"
es_config_url="https://github.com/trashbus99/profork/raw/master/steam/shortcuts/es_configs/es_systems_ps4.cfg"
es_config_path="${es_config_dir}/es_systems_ps4.cfg"

# Create ps4 directory if it doesn't exist
if [ ! -d "$ps4_dir" ]; then
    mkdir -p "ps4"
fi

# Download +UPDATE-HEROIC-SHORTCUTS.sh and make it executable
curl -L "$update_script_url" -o "$update_script_path"
chmod +x "$update_script_path"

# Download es_systems_ps4.cfg
if [ ! -d "$es_config_dir" ]; then
    mkdir -p "$es_config_dir"
fi
curl -L "$es_config_url" -o "$es_config_path"

wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /userdata/system/configs/emulationstation/es_features_ps4.cfg https://github.com/trashbus99/profork/raw/master/steam/shortcuts/es_configs/es_features_ps4.cfg &
#wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /userdata/system/configs/evmapy/Heroic2.keys https://github.com/trashbus99/profork/raw/master/steam/shortcuts/es_configs/keys/Heroic2.keys &
#wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /userdata/system/configs/evmapy/Heroic2.keys https://github.com/trashbus99/profork/raw/master/steam/shortcuts/es_configs/keys/heroic2.keys &
    wait
        dos2unix /userdata/system/configs/evmapy/*.keys 2>/dev/null

# lutris
# if [[ -e /userdata/system/configs/emulationstation/es_systems_lutris.cfg ]]; then 
#    wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /userdata/system/configs/emulationstation/es_systems_lutris.cfg https://github.com/trashbus99/profork/raw/master/steam/shortcuts/es_configs/es_systems_lutris.cfg &
#    wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /userdata/system/configs/emulationstation/es_features_lutris.cfg https://github.com/trashbus99/profork/raw/master/steam/shortcuts/es_configs/es_features_lutris.cfg &
#   wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /userdata/system/configs/evmapy/Lutris.keys https://github.com/trashbus99/profork/raw/master/steam/shortcuts/es_configs/keys/Lutris.keys &
#  wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /userdata/system/configs/evmapy/Lutris.keys https://github.com/trashbus99/profork/raw/master/steam/shortcuts/es_configs/keys/lutris.keys &
#     wait
#            dos2unix /userdata/system/configs/evmapy/*.keys 2>/dev/null
# fi

curl http://127.0.0.1:1234/reloadgames
# Clear dialog (necessary for some terminal environments)
clear
echo "Done"
