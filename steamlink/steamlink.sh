#!/bin/bash
# Check if Xwayland is running
if ! pgrep -x "Xwayland" > /dev/null; then
    echo "❌ Xwayland is not running. Exiting."
    exit 1
fi

echo "✅ Xwayland detected. Continuing..."
sleep 2
# Define variables
PORTMASTER_DIR="/userdata/system/.local/share/PortMaster"
PM_INSTALL_URL="https://github.com/trashbus99/profork/raw/master/portmaster/install.sh"
STEAMLINK_URL="https://github.com/trashbus99/ROCKNIX.apps/releases/download/files/steamlink.tar.gz"
INSTALL_DIR="/userdata/roms/ports/"
TARBALL="steamlink.tar.gz"
SCRIPT_PATH="${INSTALL_DIR}Steamlink.sh"

# Ensure dialog is installed
if ! command -v dialog &>/dev/null; then
    echo "Error: 'dialog' is required but not installed."
    exit 1
fi

# Check if PortMaster is installed
if [[ ! -d "$PORTMASTER_DIR" ]]; then
    dialog --title "PortMaster Not Found" --yesno "PortMaster is required but not installed.\n\nDo you want to install it now?" 10 60
    
    if [[ $? -eq 0 ]]; then
        # Install PortMaster
        (
            curl -L "$PM_INSTALL_URL" | bash
            echo "100"
        ) | dialog --gauge "Installing PortMaster..." 8 50 0
        
        dialog --title "Setup Required" --msgbox "PortMaster has been installed!\n\nPlease run PortMaster at least once to complete setup, then relaunch this installer." 10 60
        exit 1
    else
        dialog --msgbox "Installation aborted. Please install and set up PortMaster first." 8 50
        exit 1
    fi
fi

# Show the credits
dialog --title "Steamlink Installer" --msgbox "Thanks and Credits to Noxwell and Jeodc on the PortMaster team for this release." 8 60

# Ask the user to confirm PortMaster setup
dialog --title "PortMaster Setup Check" --yesno "This app requires PortMaster to be set up and run at least once to work.\n\nHave you set up PortMaster?" 10 60

if [[ $? -ne 0 ]]; then
    dialog --msgbox "Please run PortMaster at least once before installing Steamlink." 8 50
    exit 1
fi

# Download the file using curl with a progress bar
(
    curl -L "$STEAMLINK_URL" -o "/tmp/$TARBALL" --progress-bar
    echo "100"
) | dialog --gauge "Downloading Steamlink..." 8 50 0

# Verify if the download was successful
if [[ ! -f "/tmp/$TARBALL" ]]; then
    dialog --title "Error" --msgbox "Download failed. Please check your internet connection and try again." 8 50
    exit 1
fi

# Extract the tarball
mkdir -p "$INSTALL_DIR"
tar -xzvf "/tmp/$TARBALL" -C "$INSTALL_DIR" | dialog --progressbox "Installing Steamlink..." 10 50

# Ensure Steamlink.sh is executable
if [[ -f "$SCRIPT_PATH" ]]; then
    chmod +x "$SCRIPT_PATH"
else
    dialog --title "Warning" --msgbox "Steamlink.sh was not found after extraction. Installation may be incomplete." 8 50
fi

# Cleanup
rm -f "/tmp/$TARBALL"

# Confirm installation completion
dialog --title "Installation Complete" --msgbox "Steamlink has been successfully installed!\n\nYou can now launch it from Ports." 8 50

exit 0
