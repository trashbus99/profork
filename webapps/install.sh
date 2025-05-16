#!/bin/bash

# Define the file path
filePath="$HOME/pro/steam/conty.sh"

# Check if the file exists
if [ -f "$filePath" ]; then
    echo "File exists, continuing the script..."
   
else
    echo "It appears the container is not installed. Please install the Arch Steam/lutris/heroic container first, then retry."
    sleep 10
    exit 1
fi


# Display a dialog message box
dialog --title "Webapps Installer" --msgbox "This script will install a New system called webapps and ES Menu in Batocera to ~/webapps & /userdata/roms/webapps that lets you create Google Shortcuts and Electron WebApps." 10 50

# Proceed with the rest of the script

# Define base URL for downloads
BASE_URL="https://github.com/trashbus99/profork/raw/master/webapps"

# Create the ~/webapps directory
mkdir -p ~/webapps

# Download the specified scripts into ~/webapps
curl -L https://github.com/trashbus99/profork/raw/master/webapps/native.sh -o ~/webapps/native.sh
curl -L https://github.com/trashbus99/profork/raw/master/webapps/nlaunch.sh -o ~/webapps/nlaunch.sh
curl -L https://github.com/trashbus99/profork/raw/master/webapps/chrome.sh -o ~/webapps/chrome.sh
curl -L https://github.com/trashbus99/profork/raw/master/webapps/webapps.sh -o ~/webapps/webapps.sh

# Make downloaded scripts executable
chmod +x ~/webapps/native.sh
chmod +x ~/webapps/nlaunch.sh
chmod +x ~/webapps/chrome.sh
chmod +x ~/webapps/webapps.sh

# Create the /userdata/roms/webapps directory
mkdir -p /userdata/roms/webapps

# Download the Add-WebApp.sh script into /userdata/roms/webapps
curl -L https://github.com/trashbus99/profork/raw/master/webapps/Add-WebApp.sh -o /userdata/roms/webapps/+ADD-WEB-APPS.sh

# Make the downloaded Add-WebApp.sh script executable
chmod +x /userdata/roms/webapps/+ADD-WEB-APPS.sh

# Create the ~/configs/emulationstation directory
mkdir -p ~/configs/emulationstation

# Download the es_systems_webapps.cfg file into ~/configs/emulationstation
curl -L https://github.com/trashbus99/profork/raw/master/webapps/es_systems_webapps.cfg -o ~/configs/emulationstation/es_systems_webapps.cfg
curl -L https://github.com/trashbus99/profork/raw/master/webapps/es_features_webapps.cfg -o ~/configs/emulationstation/es_features_webapps.cfg

echo "All files have been downloaded and placed in their respective directories. Scripts have been made executable."
sleep 5
curl http://127.0.0.1:1234/reloadgames
