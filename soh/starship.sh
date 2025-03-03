#!/bin/bash

# Step 1: Define Directories and URLs
STARSHIP_DIR="/userdata/roms/ports/starship"
LAUNCH_SCRIPT="/userdata/roms/ports/Starship.sh"
STARSHIP_APPIMAGE="Starship-x86_64.AppImage"
STARSHIP_URL="https://github.com/qurious-pixel/Starship/releases/download/v1.0/Starship-x86_64.AppImage"
KEYS_FILE="/userdata/roms/ports/starship.sh.keys"
KEYS_URL="https://raw.githubusercontent.com/trashbus99/profork/refs/heads/master/soh/launch_soh.sh.keys"

# Ensure the directory exists
mkdir -p "$STARSHIP_DIR"

# Step 2: Download Starship AppImage if it doesn't exist
if [ ! -f "$STARSHIP_DIR/$STARSHIP_APPIMAGE" ]; then
    echo "Downloading Starship (Starfox 64 Engine)..."
    wget -O "$STARSHIP_DIR/$STARSHIP_APPIMAGE" "$STARSHIP_URL"
fi

# Ensure the AppImage is executable
chmod +x "$STARSHIP_DIR/$STARSHIP_APPIMAGE"

# Step 3: Create the Launch Script
cat << EOF > "$LAUNCH_SCRIPT"
DISPLAY=:0.0 xterm -fs 30 -maximized -fg white -bg black -fa "DejaVuSansMono" -en UTF-8 -e bash -c '
    export DISPLAY=:0.0;
    cd "/userdata/roms/ports/starship" || { echo "Error: Failed to change directory"; exit 1; }
    chmod +x "Starship-x86_64.AppImage";
    exec ./Starship-x86_64.AppImage > /dev/null 2>&1
'
EOF

# Make the launch script executable
chmod +x "$LAUNCH_SCRIPT"

# Step 4: Download the Key Bindings File
echo "Downloading launch_2s2h.sh.keys file..."
wget -O "$KEYS_FILE" "$KEYS_URL"

# Step 5: Display Instructions using dialog
dialog --msgbox "Setup complete! 🎮\n\n\ 18 50
To run Starship (Starfox 64 Engine):\n\
- Go to the PORTS section in Batocera.\n\
- Launch the game from there.\n\n\
Make sure to place your legally obtained Starfox 64 ROM file in:\n\
$STARSHIP_DIR\n\n\
The ROM should have the correct CRC/SHA1 hash as outlined in the README." 12 60
clear
