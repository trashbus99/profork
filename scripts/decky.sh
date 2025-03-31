#!/bin/bash

# Animated message at the beginning
clear
echo -n "This script will install Decky to Steam on Batocera"
for i in {1..3}; do
    echo -n "."
    sleep 0.5
done
echo ""

# Set variables
PLUGIN_URL="https://github.com/SteamDeckHomebrew/decky-loader/releases/download/v3.1.3/PluginLoader"
DEST_DIR="/userdata/system/homebrew/services"
CUSTOM_SH="/userdata/system/custom.sh"
FLATPAK_STEAM_DEBUG_FILE="/userdata/saves/flatpak/data/.var/app/com.valvesoftware.Steam/data/Steam.cef-enable-remote-debugging"
ARCH_STEAM_DEBUG_FILE="$HOME/.local/share/Steam/.cef-enable-remote-debugging"

# Check for Flatpak or Arch container Steam directories and create CEF debugging file in both if they exist
DEBUGGING_SETUP=false

# Check and install for Flatpak Steam
if [ -d "$(dirname "$FLATPAK_STEAM_DEBUG_FILE")" ]; then
    echo "Flatpak Steam detected. Enabling CEF debugging in $FLATPAK_STEAM_DEBUG_FILE..."
    mkdir -p "$(dirname "$FLATPAK_STEAM_DEBUG_FILE")"
    touch "$FLATPAK_STEAM_DEBUG_FILE"
    DEBUGGING_SETUP=true
fi

# Check and install for Arch container Steam
if [ -d "$(dirname "$ARCH_STEAM_DEBUG_FILE")" ]; then
    echo "Arch container Steam detected. Enabling CEF debugging in $ARCH_STEAM_DEBUG_FILE..."
    mkdir -p "$(dirname "$ARCH_STEAM_DEBUG_FILE")"
    touch "$ARCH_STEAM_DEBUG_FILE"
    DEBUGGING_SETUP=true
fi

# If neither directory was found, exit with an error message
if [ "$DEBUGGING_SETUP" = false ]; then
    echo "Neither Flatpak nor Arch Steam directories found."
    echo "Please run Steam at least once before running this script."
    sleep 5
    exit 1
fi

# Proceed with PluginLoader installation only if at least one CEF debugging file was set up successfully
echo "CEF debugging setup complete. Continuing with Decky installation."

# Create the destination directory if it doesn't exist
echo "Creating directory: $DEST_DIR..."
mkdir -p "$DEST_DIR"

# Download the PluginLoader binary
echo "Downloading PluginLoader..."
curl -L -o "$DEST_DIR/PluginLoader" "$PLUGIN_URL"

# Mark the PluginLoader binary as executable
echo "Setting executable permissions..."
chmod +x "$DEST_DIR/PluginLoader"

# Add PluginLoader to Batocera's autostart script (custom.sh)
echo "Updating $CUSTOM_SH to autostart PluginLoader..."
if ! grep -Fxq "$DEST_DIR/PluginLoader &" "$CUSTOM_SH"; then
    echo "$DEST_DIR/PluginLoader &" >> "$CUSTOM_SH"
    echo "PluginLoader added to $CUSTOM_SH."
else
    echo "PluginLoader is already in $CUSTOM_SH. No changes made."
fi

echo "Setup complete. Decky PluginLoader is installed and configured to start on next boot."
echo "Please Reboot Batocera for it to take effect"
sleep 10
