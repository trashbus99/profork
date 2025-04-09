#!/bin/bash

# Step 1: Make sure we're in a temp working dir
cd /userdata/roms/ports || exit 1

# Step 2: Download the tar.gz
echo "Downloading Rockbot..."
curl -L -o rockbot2.tar.gz https://github.com/trashbus99/profork/releases/download/r1/rockbot2.tar.gz

# Step 3: Extract it
echo "Extracting Rockbot..."
tar -xvzf rockbot2.tar.gz

# Step 4: Remove the tar.gz to save space
rm -f rockbot2.tar.gz

# Step 5: Create the launcher script
echo "Creating Rockbot2.sh launcher..."
cat << 'EOF' > /userdata/roms/ports/Rockbot.sh
#!/bin/bash
cd /userdata/roms/ports/rockbot2
DISPLAY=:0.0 LD_LIBRARY_PATH=/usr/lib64:/lib64:./libs ./rockbot
EOF

# Step 6: Make the launcher executable
chmod +x /userdata/roms/ports/Rockbot2.sh

echo "Done! Rockbot installed."
sleep 5
