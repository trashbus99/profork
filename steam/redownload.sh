#!/bin/bash

# Get the machine hardware name
architecture=$(uname -m)

# Check if the architecture is x86_64 (AMD/Intel)
if [ "$architecture" != "x86_64" ]; then
    echo "This script only runs on AMD or Intel (x86_64) CPUs, not on $architecture."
    exit 1
fi

clear 

# Function to display animated title
animate_title() {
    local text="Downloading Conty Container"
    local delay=0.1
    local length=${#text}

    for (( i=0; i<length; i++ )); do
        echo -n "${text:i:1}"
        sleep $delay
    done
    echo
}

# Main script execution
clear
animate_title


rm /userdata/system/pro/steam/prepare.sh 2>/dev/null

rm /userdata/system/pro/steam/conty.sh 2>/dev/null
curl -L aria2c.batocera.pro | bash && ./aria2c -x 5 -d  /userdata/system/pro/steam http://batocera.pro/app/conty.sh && rm aria2c
chmod 777 /userdata/system/pro/steam/conty.sh 2>/dev/null

wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /userdata/system/pro/steam/batocera-conty-patcher.sh https://github.com/trashbus99/profork/raw/main/main/steam/build/batocera-conty-patcher.sh
dos2unix /userdata/system/pro/steam/batocera-conty-patcher.sh 2>/dev/null
chmod 777 /userdata/system/pro/steam/batocera-conty-patcher.sh 2>/dev/null

echo "DONE"
sleep 5
