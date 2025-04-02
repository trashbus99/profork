#!/bin/bash

# Step 1: Download videostart86.sh to /userdata/system/scripts
mkdir -p ~/scripts
wget -O /userdata/system/scripts/videostart86.sh https://github.com/trashbus99/profork/raw/master/scripts/videostart86.sh

# Step 2: Convert the file to Unix format
dos2unix /userdata/system/scripts/videostart86.sh

# Step 3: Make the script executable
chmod +x /userdata/system/scripts/videostart86.sh

# Step 4: Create the directory if it doesn't exist
mkdir -p /userdata/loadingscreens

# Step 5: Download logos.zip
wget -O /userdata/loadingscreens/logos.zip hhttps://github.com/trashbus99/profork/raw/master/scripts/splash.zip

# Step 6: Extract logos.zip to /userdata/loadingscreens
unzip -o /userdata/loadingscreens/logos.zip -d /userdata/loadingscreens/

# Step 7: Delete logos.zip after extraction
rm /userdata/loadingscreens/logos.zip

# Step 8: Announce done
clear
echo "Download and setup completed!"

echo "To add more or custom splash videos, drop mp4s in /userdata/loadingscreens matching rom folder name"
