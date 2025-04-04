#!/bin/bash

# Show credit message
clear
echo "==============================================="
echo "   Megaman RocknRoll Installer"
echo "   Source: https://dennisengelhard.com/rock-n-roll/"
echo "==============================================="
sleep 5

# Define variables
ZIP_URL="https://dennisengelhard.com/wp-content/uploads/2021/01/megaman_rocknroll_linux_1.3.zip"
TARGET_DIR="/userdata/roms/ports/mmrnr"
LAUNCHER="/userdata/roms/ports/Megaman_RocknRoll.sh"

# Create target directory
mkdir -p "$TARGET_DIR"

# Download the zip file
wget -O "$TARGET_DIR/megaman_rocknroll.zip" "$ZIP_URL"

# Extract contents
unzip -o "$TARGET_DIR/megaman_rocknroll.zip" -d "$TARGET_DIR"

# Make the main executable executable
chmod +x "$TARGET_DIR/MegaMan_RocknRoll"

# Create launcher script
cat > "$LAUNCHER" <<EOF
#!/bin/bash
cd "$TARGET_DIR"
DISPLAY=:0.0 ./MegaMan_RocknRoll
EOF

# Make launcher executable
chmod +x "$LAUNCHER"

echo "Done! You can now run Megaman Rock N Roll from your ports folder."
