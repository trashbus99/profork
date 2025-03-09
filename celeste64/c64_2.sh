#!/bin/bash

# Determine system architecture
arch=$(uname -m)
echo "Detected architecture: $arch"

# Repository and asset suffixes
REPO="trashbus99/profork"
AMD_SUFFIX="Celeste64-v1.1.1-Linux-x64.zip"
ARM_SUFFIX="Celeste64-v1.1.1-Linux-arm64.zip"

# Choose the correct download URL based on the architecture
if [ "$arch" == "x86_64" ]; then
    echo "Architecture: x86_64 detected."
    DOWNLOAD_URL=$(curl -s "https://api.github.com/repos/$REPO/releases/latest" | \
        jq -r ".assets[] | select(.name | endswith(\"$AMD_SUFFIX\")) | .browser_download_url")
elif [ "$arch" == "aarch64" ]; then
    echo "Architecture: arm64 detected."
    if [ -n "$ARM_SUFFIX" ]; then
        DOWNLOAD_URL=https://github.com/EXOK/Celeste64/releases/download/v1.1.1/Celeste64-v1.1.1-Linux-arm64.zip
    else
        echo "No ARM64 binary suffix provided. Skipping download. Exiting."
        exit 1
    fi
else
    echo "Unsupported architecture: $arch"
    exit 1
fi

# Set variables for installation paths
DEST_DIR="/userdata/roms/ports/celeste64"
SCRIPT_PATH="/userdata/roms/ports/Celeste64.sh"
ZIP_FILE="/tmp/Celeste64.zip"

# Create destination directory if it doesn't exist
mkdir -p "$DEST_DIR"

# Download the file with a progress bar
curl -L --progress-bar "$DOWNLOAD_URL" -o "$ZIP_FILE"

# Extract the contents to the destination directory
unzip -o "$ZIP_FILE" -d "$DEST_DIR"

# Remove the downloaded zip file
rm "$ZIP_FILE"

# Create the launch script
cat << EOF > "$SCRIPT_PATH"
#!/bin/bash
cd "$DEST_DIR"
DISPLAY=:0.0 ./Celeste64
EOF

# Make the launch script executable
chmod +x "$SCRIPT_PATH"

# Inform the user
echo "Celeste64 has been added to Ports!"
echo "Please update your gamelists to see it in your menu."
sleep 8
