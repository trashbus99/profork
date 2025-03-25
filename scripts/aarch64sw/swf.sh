#!/usr/bin/env bash
#
# SWITCH FRAMEWORK INSTALLER FOR BATOCERA
#
# This installer sets up the framework for Nintendo Switch emulation,
# creating desktop entries and launchers for both Citron and Ryujinx.
#
# It also installs a basic xdg-open wrapper that launches PCManFM,
# because Batocera does not provide a functional xdg-open.
#
# IMPORTANT: You must manually copy your Citron.AppImage and Ryujinx.AppImage
# into /userdata/system/pro/switch and ensure they are executable.
#

# Check if Xwayland is running
if ! pgrep -x "Xwayland" > /dev/null; then
    echo "❌ Xwayland is not running. Exiting."
    exit 1
fi
echo "✅ Xwayland detected. Continuing..."
sleep 2

# Inform the user about the experimental nature of the Switch Framework
dialog --title "Switch Framework Notice" --yesno "This installer will set up the Switch Framework for Batocera. You must manually place your Citron.AppImage and Ryujinx.AppImage in /userdata/system/pro/switch and make them executable. Continue installing?" 12 60
if [ $? -ne 0 ]; then
    echo "Installation canceled by user."
    exit 1
fi

clear
echo "Preparing Switch Framework installer, please wait..."

# Define variables
APPNAME="SWITCH"
appdir="switch"
PRO_DIR="/userdata/system/pro"
SWITCH_DIR="$PRO_DIR/$appdir"
EXTRA_DIR="$SWITCH_DIR/extra"
PORTS_DIR="/userdata/roms/ports"
ES_CONFIG_DIR="/userdata/system/configs/emulationstation"
CUSTOM_SH="/userdata/system/custom.sh"

# Create required directories
mkdir -p "$SWITCH_DIR" "$EXTRA_DIR" "$PORTS_DIR" "$ES_CONFIG_DIR"

###########################
# Download Icons for Switch
###########################
echo "Downloading Citron icon..."
curl -# -o "$EXTRA_DIR/citron.png" "https://github.com/foclabroc/batocera-switch/raw/main/system/switch/extra/citron.png"
echo "Downloading Ryujinx icon..."
curl -# -o "$EXTRA_DIR/icon_ryujinx.png" "https://github.com/foclabroc/batocera-switch/raw/main/system/switch/extra/icon_ryujinx.png"

############################################
# Inform User About AppImage Placement
############################################
echo "IMPORTANT: Please manually copy your Citron.AppImage and Ryujinx.AppImage to:"
echo "  $SWITCH_DIR"
echo "and run 'chmod +x' on them to make them executable."
sleep 4

############################################
# Download Update Shortcuts Script
############################################
echo "Downloading update-shortcuts script..."
UPDATE_SCRIPT="$SWITCH_DIR/+UPDATE-SHORTCUTS.sh"
curl -# -o "$UPDATE_SCRIPT" "https://github.com/trashbus99/profork/raw/master/scripts/aarch64sw/UPDATE-SHORTCUTS.sh"
dos2unix "$UPDATE_SCRIPT" 2>/dev/null
chmod +x "$UPDATE_SCRIPT"

############################################
# Download EmulationStation Config Files
############################################
echo "Downloading EmulationStation configuration files..."
curl -# -o "$ES_CONFIG_DIR/es_features_citron.cfg" "https://github.com/trashbus99/profork/raw/master/scripts/aarch64sw/es_features_citron.cfg"
echo "Downloaded: es_features_citron.cfg"
# For Ryujinx, using the same config file for now:
curl -# -o "$ES_CONFIG_DIR/es_features_ryujinx.cfg" "https://github.com/trashbus99/profork/raw/master/scripts/aarch64sw/es_features_citron.cfg"
echo "Downloaded: es_features_ryujinx.cfg"

############################################
# Create Desktop Entries for Launchers
############################################
# Create Citron Desktop Entry in extra folder
CITRON_DESKTOP="$EXTRA_DIR/switch_citron.desktop"
rm -f "$CITRON_DESKTOP"
echo "[Desktop Entry]" >> "$CITRON_DESKTOP"
echo "Version=1.0" >> "$CITRON_DESKTOP"
echo "Name=Citron" >> "$CITRON_DESKTOP"
echo "Comment=Launch Citron for Nintendo Switch" >> "$CITRON_DESKTOP"
echo "Icon=$EXTRA_DIR/citron.png" >> "$CITRON_DESKTOP"
echo "Exec=$SWITCH_DIR/citron.AppImage --appimage-extract-and-run %U" >> "$CITRON_DESKTOP"
echo "Terminal=false" >> "$CITRON_DESKTOP"
echo "Type=Application" >> "$CITRON_DESKTOP"
echo "Categories=Game;batocera.linux;" >> "$CITRON_DESKTOP"

# Create Ryujinx Desktop Entry in extra folder
RYUJINX_DESKTOP="$EXTRA_DIR/switch_ryujinx.desktop"
rm -f "$RYUJINX_DESKTOP"
echo "[Desktop Entry]" >> "$RYUJINX_DESKTOP"
echo "Version=1.0" >> "$RYUJINX_DESKTOP"
echo "Name=Ryujinx" >> "$RYUJINX_DESKTOP"
echo "Comment=Launch Ryujinx for Nintendo Switch" >> "$RYUJINX_DESKTOP"
echo "Icon=$EXTRA_DIR/icon_ryujinx.png" >> "$RYUJINX_DESKTOP"
echo "Exec=$SWITCH_DIR/ryujinx.AppImage --appimage-extract-and-run %U" >> "$RYUJINX_DESKTOP"
echo "Terminal=false" >> "$RYUJINX_DESKTOP"
echo "Type=Application" >> "$RYUJINX_DESKTOP"
echo "Categories=Game;batocera.linux;" >> "$RYUJINX_DESKTOP"

chmod a+x "$CITRON_DESKTOP" "$RYUJINX_DESKTOP"

# Copy desktop entries to /usr/share/applications temporarily (they will be re-copied on boot)
cp "$CITRON_DESKTOP" /usr/share/applications/ 2>/dev/null
cp "$RYUJINX_DESKTOP" /usr/share/applications/ 2>/dev/null

############################################
# Create Launcher Scripts in Ports
############################################
# Citron Launcher Script for Ports
CITRON_PORT="$PORTS_DIR/Switch_Citron.sh"
cat << EOF > "$CITRON_PORT"
#!/bin/bash
export DISPLAY=:0.0
batocera-mouse show
"$SWITCH_DIR/citron.AppImage" --appimage-extract-and-run "\$@"
batocera-mouse hide
EOF

# Ryujinx Launcher Script for Ports
RYUJINX_PORT="$PORTS_DIR/Switch_Ryujinx.sh"
cat << EOF > "$RYUJINX_PORT"
#!/bin/bash
export DISPLAY=:0.0
batocera-mouse show
"$SWITCH_DIR/ryujinx.AppImage" --appimage-extract-and-run "\$@"
batocera-mouse hide
EOF

chmod a+x "$CITRON_PORT" "$RYUJINX_PORT"

############################################
# Setup Basic XDG Framework (xdg-open Wrapper)
############################################
# Create a simple wrapper script that calls PCManFM
XDG_WRAPPER="$SWITCH_DIR/xdg-open"
rm -f "$XDG_WRAPPER"
echo "#!/bin/bash" >> "$XDG_WRAPPER"
echo "pcmanfm \"\$@\"" >> "$XDG_WRAPPER"
chmod a+x "$XDG_WRAPPER"
echo "Created xdg-open wrapper at $XDG_WRAPPER"

# To ensure this wrapper is found, add its directory to the PATH on boot
if [ -e "$CUSTOM_SH" ]; then
    if ! grep -q "export PATH=\"$SWITCH_DIR:\$PATH\"" "$CUSTOM_SH"; then
        echo -e "\nexport PATH=\"$SWITCH_DIR:\$PATH\"" >> "$CUSTOM_SH"
    fi
else
    echo -e "\nexport PATH=\"$SWITCH_DIR:\$PATH\"" >> "$CUSTOM_SH"
fi

############################################
# Prepare Prelauncher to Avoid Overlay Reset
############################################
PRELAUNCHER="$EXTRA_DIR/startup"
rm -f "$PRELAUNCHER"
echo "#!/usr/bin/env bash" >> "$PRELAUNCHER"
echo "cp $EXTRA_DIR/switch_citron.desktop /usr/share/applications/ 2>/dev/null" >> "$PRELAUNCHER"
echo "cp $EXTRA_DIR/switch_ryujinx.desktop /usr/share/applications/ 2>/dev/null" >> "$PRELAUNCHER"
dos2unix "$PRELAUNCHER" 2>/dev/null
chmod a+x "$PRELAUNCHER"

# Add the prelauncher to custom.sh so it runs at boot
if [ -e "$CUSTOM_SH" ]; then
    if ! grep -q "$PRELAUNCHER" "$CUSTOM_SH"; then
        echo -e "\n$PRELAUNCHER" >> "$CUSTOM_SH"
    fi
else
    echo -e "\n$PRELAUNCHER" >> "$CUSTOM_SH"
fi
dos2unix "$CUSTOM_SH" 2>/dev/null

############################################
# Final Message
############################################
dialog --msgbox "✅ Switch Framework installation complete!

• Please manually place your Citron.AppImage and Ryujinx.AppImage in:
   $SWITCH_DIR
   and ensure they are executable (chmod +x).
• The update-shortcuts script has been downloaded to:
   $UPDATE_SCRIPT
• Desktop entries for Citron and Ryujinx have been created and will persist on boot.
• Launchers have been added to the ports menu.
• A basic xdg-open wrapper has been installed that uses PCManFM. Its path is added to your PATH at boot.

You can now configure your emulators via EmulationStation.
" 20 70

echo "Switch Framework installation complete!"
sleep 2
exit 0

