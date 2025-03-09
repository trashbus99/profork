#!/usr/bin/env bash

echo "Profork SHADPS4 Installer..."
echo "This will install SHADPS4 to /userdata/system/pro/shadps4"
echo ""
echo "A Launcher will be added to F1->Applications"
echo "and a New menu will be added to Emulationstation for PS4" 
sleep 7

RED='\033[1;31m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
RESET='\033[0m'

# -----------------------------------------------------------------------------
# Preliminary Checks & Dialogs
# -----------------------------------------------------------------------------
architecture=$(uname -m)
if [ "$architecture" != "x86_64" ]; then
    echo -e "${RED}This installer only runs on x86_64 systems (AMD/Intel). Detected: $architecture.${RESET}"
    exit 1
fi

if dialog --title "Compatibility Warning" --yesno "Warning: ShadPS4 only works on v40+ and higher.\n\nContinue installation?" 10 60; then
    echo -e "${GREEN}Continuing installation...${RESET}"
else
    clear
    echo -e "${RED}Installation aborted by user.${RESET}"
    exit 1
fi

clear

# -----------------------------------------------------------------------------
# Define Variables & Paths
# -----------------------------------------------------------------------------
INSTALL_DIR="/userdata/system/pro/shadps4"
ROMS_DIR="/userdata/roms/ps4"
IMAGE_DIR="$INSTALL_DIR/images"
RESTORE_DIR="$INSTALL_DIR/extra"
STARTUP_SCRIPT="$RESTORE_DIR/startup"

PRO_CUSTOM_SH="/userdata/system/pro-custom.sh"
CUSTOM_SH="/userdata/system/custom.sh"

ES_CONFIG_DIR="/userdata/system/configs/emulationstation"

DESKTOP_ENTRY="$INSTALL_DIR/shadps4.desktop"
LAUNCHER_SCRIPT="$INSTALL_DIR/launch_shadps4.sh"
ICON_DIR="$INSTALL_DIR/extra"
ICON_PATH="$ICON_DIR/shadps4.png"

# Ensure required directories exist
mkdir -p "$INSTALL_DIR" "$IMAGE_DIR" "$ROMS_DIR" "$RESTORE_DIR" "$ES_CONFIG_DIR" "$ICON_DIR"

# -----------------------------------------------------------------------------
# Fetch Latest ShadPS4 Release & Install
# -----------------------------------------------------------------------------
echo -e "${CYAN}Fetching latest ShadPS4 release...${RESET}"
latest_release_url=$(curl -s "https://api.github.com/repos/shadps4-emu/shadPS4/releases/latest" | grep "browser_download_url" | grep -E "shadps4-linux-qt-.*\.zip" | cut -d '"' -f 4)
if [ -z "$latest_release_url" ]; then
    echo -e "${RED}Failed to retrieve the latest release URL. Exiting.${RESET}"
    exit 1
fi

echo -e "${CYAN}Downloading ShadPS4 zip from:${RESET} ${YELLOW}$latest_release_url${RESET}"
curl -# -L -o "$INSTALL_DIR/shadps4.zip" "$latest_release_url"
if [ $? -ne 0 ]; then
    echo -e "${RED}Download failed. Exiting.${RESET}"
    exit 1
fi

echo -e "${CYAN}Unzipping ShadPS4...${RESET}"
unzip -o -q "$INSTALL_DIR/shadps4.zip" -d "$INSTALL_DIR"
if [ $? -ne 0 ]; then
    echo -e "${RED}Unzip failed. Exiting.${RESET}"
    exit 1
fi

rm -f "$INSTALL_DIR/shadps4.zip"
chmod a+x "$INSTALL_DIR/Shadps4-qt.AppImage"
echo -e "${GREEN}ShadPS4 installed and AppImage marked executable.${RESET}"

# -----------------------------------------------------------------------------
# Create Desktop Entry & Launcher Script
# -----------------------------------------------------------------------------
echo -e "${CYAN}Downloading icon...${RESET}"
curl -# -L -o "$ICON_PATH" "https://raw.githubusercontent.com/trashbus99/profork/master/shadps4/extra/shadps4.png"

cat << EOF > "$LAUNCHER_SCRIPT"
#!/bin/bash
cd /userdata/system/pro/shadps4
DISPLAY=:0.0 ./Shadps4-qt.AppImage "\$@"
EOF
chmod +x "$LAUNCHER_SCRIPT"

cat << EOF > "$DESKTOP_ENTRY"
[Desktop Entry]
Version=1.0
Type=Application
Name=ShadPS4
Exec=$LAUNCHER_SCRIPT
Icon=$ICON_PATH
Terminal=false
Categories=Game;batocera.linux;
EOF
chmod +x "$DESKTOP_ENTRY"
ln -sf "$DESKTOP_ENTRY" /usr/share/applications/shadps4.desktop

# -----------------------------------------------------------------------------
# Create Restore–Shortcut Script (startup)
# -----------------------------------------------------------------------------
cat << EOF > "$STARTUP_SCRIPT"
#!/bin/bash
ln -sf "$DESKTOP_ENTRY" /usr/share/applications/shadps4.desktop
EOF
chmod +x "$STARTUP_SCRIPT"

# Ensure pro-custom.sh calls startup
if ! grep -q "$STARTUP_SCRIPT" "$PRO_CUSTOM_SH" 2>/dev/null; then
    echo "bash $STARTUP_SCRIPT &" >> "$PRO_CUSTOM_SH"
    chmod +x "$PRO_CUSTOM_SH"
fi

if ! grep -q "$PRO_CUSTOM_SH" "$CUSTOM_SH" 2>/dev/null; then
    echo "bash $PRO_CUSTOM_SH &" >> "$CUSTOM_SH"
    chmod +x "$CUSTOM_SH"
fi

# -----------------------------------------------------------------------------
# Install ES Features & System Configurations for PS4
# -----------------------------------------------------------------------------
cat << EOF > "$ES_CONFIG_DIR/es_features_ps4.cfg"
<?xml version="1.0" encoding="UTF-8" ?>
<features>
    <emulator name="ps4" features="videomode,padtokeyboard,powermode,tdp,bezel,hud">
    </emulator>
    <feature name="BEZELS" value="bezel" description="Enable or disable game bezels.">
        <choice name="On" value="1" />
        <choice name="Off" value="0" />
    </feature>
    <feature name="HUD" value="hud" description="Enable or disable on-screen HUD display.">
        <choice name="On" value="1" />
        <choice name="Off" value="0" />
    </feature>
</features>
EOF

cat << EOF > "$ES_CONFIG_DIR/es_systems_ps4.cfg"
<?xml version="1.0"?>
<systemList>
  <system>
        <fullname>PlayStation 4</fullname>
        <name>ps4</name>
        <manufacturer>Sony</manufacturer>
        <release>2013</release>
        <hardware>port</hardware>
        <path>/userdata/roms/ps4</path>
        <extension>.sh</extension>
        <command>emulatorlauncher %CONTROLLERSCONFIG% -system ports -rom %ROM% -gameinfoxml %GAMEINFOXML% -systemname ports</command>
        <platform>ps4</platform>
        <theme>ps4</theme>
        <emulators>
            <emulator name="ps4">
                <cores>
                    <core default="ps4">shadps4</core>
                </cores>
            </emulator>
        </emulators>
  </system>
</systemList>
EOF

# -----------------------------------------------------------------------------
# Create +UPDATE-PS4-SHORTCUTS.sh with pad2 keys generation
# -----------------------------------------------------------------------------
cat << 'EOF' > "$ROMS_DIR/+UPDATE-PS4-SHORTCUTS.sh"
#!/bin/bash

desktop_dir="/userdata/system/Desktop"
output_dir="/userdata/roms/ps4"
mkdir -p "$output_dir"

for file_path in "$desktop_dir"/*.desktop; do
    if [ -f "$file_path" ] && grep -q 'shadps4' "$file_path"; then
        game_name=$(grep '^Name=' "$file_path" | sed 's/^Name=//')
        game_path=$(grep '^Exec=' "$file_path" | sed -n 's/.*"\([^"]*\/eboot\.bin\)".*/\1/p')
        game_code=$(basename "$(dirname "$game_path")")

        sanitized_name=$(echo "$game_name" | sed 's/ /_/g' | sed 's/[^a-zA-Z0-9_]//g')
        script_path="$output_dir/${sanitized_name}.sh"
        keys_path="$output_dir/${sanitized_name}.sh.keys"

        echo "#!/bin/bash
ulimit -H -n 819200 && ulimit -S -n 819200
batocera-mouse show
DISPLAY=:0.0 \"/userdata/system/pro/shadps4/Shadps4-qt.AppImage\" -g $game_code -f true
batocera-mouse hide" > "$script_path"

        chmod +x "$script_path"
        echo "Shortcut created: $script_path"

        # Create keys file with default mappings and a pad2 entry that includes the game name
        cat << KEYS_EOF > "$keys_path"
{
    "actions_player1": [
        {
            "trigger": [
                "hotkey",
                "start"
            ],
            "type": "key",
            "target": [
                "KEY_LEFTALT",
                "KEY_F4"
            ],
            "description": "Press Alt+F4"
        },
        {
            "trigger": [
                "hotkey",
                "l2"
            ],
            "type": "key",
            "target": "KEY_ESC",
            "description": "Press Esc"
        },
        {
            "trigger": [
                "hotkey",
                "r2"
            ],
            "type": "key",
            "target": "KEY_ENTER",
            "description": "Press Enter"
        },
        {
            "trigger": [
                "hotkey",
                "pad2"
            ],
            "type": "key",
            "target": "KEY_P",
            "description": "Launch ${game_name}"
        }
    ]
}
KEYS_EOF

        echo "Keys file created: $keys_path"
    fi
done

killall -9 emulationstation
EOF
chmod +x "$ROMS_DIR/+UPDATE-PS4-SHORTCUTS.sh"

# -----------------------------------------------------------------------------
# Inform the User about Shortcut Creation
# -----------------------------------------------------------------------------
dialog --title "Manual Shortcut Update Required" --msgbox "IMPORTANT:\n1️⃣ Open the **ShadPS4 GUI** and manually create game shortcuts from each game installed.\n2️⃣ Then, **run the PS4 menu update script**: \n   *+UPDATE-PS4-SHORTCUTS.sh* (in the es PS4 menu).\n\nPress OK to finish installation." 12 60

# -----------------------------------------------------------------------------
# Final Steps & Cleanup
# -----------------------------------------------------------------------------
echo -e "${GREEN}ShadPS4 installation finished.${RESET}"
exit 0
