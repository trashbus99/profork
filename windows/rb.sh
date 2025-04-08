#!/bin/bash

# Step 1: Make sure we're in a temp working dir
cd /userdata/roms/ports || exit 1

# Step 2: Download the tar.gz
echo "Downloading Rockbot..."
curl -L -o rockbot.tar.gz https://github.com/trashbus99/profork/releases/download/r1/rockbot.tar.gz

# Step 3: Extract it
echo "Extracting Rockbot..."
tar -xvzf rockbot.tar.gz

# Step 4: Remove the tar.gz to save space
rm -f rockbot.tar.gz

# Step 5: Create the launcher script
echo "Creating Rockbot.sh launcher..."
cat << 'EOF' > /userdata/roms/ports/Rockbot.sh
#!/bin/bash
cd /userdata/roms/ports/rockbot
DISPLAY=:0.0 LD_LIBRARY_PATH=/usr/lib64:/lib64:./libs ./rockbot
EOF

# Step 6: Make the launcher executable
chmod +x /userdata/roms/ports/Rockbot.sh

echo "Done! Rockbot installed."
sleep 5
