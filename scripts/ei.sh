#!/bin/bash

# Temp file for dialog output
TMPFILE=$(mktemp)
trap "rm -f $TMPFILE" EXIT

# Paths
PRO_DIR="/userdata/system/pro"
EFI_DIR="$PRO_DIR/efi"
DIALOGRC_PATH="$PRO_DIR/.dialogrc"
EFI_SCRIPT_PATH="$EFI_DIR/efi.sh"
PORTS_DIR="/userdata/roms/ports"
PORTS_LAUNCHER="$PORTS_DIR/efibootmgr.sh"
PORTS_KEYS="$PORTS_DIR/efibootmgr.sh.keys"

# Step 0: Confirm
dialog --title "Install EFIBOOTMGR Launcher" --yesno "This will download:\n\n- efi.sh (main menu)\n- .dialogrc (for dialog colors)\n- efibootmgr.sh.keys (for gamepad controls)\n\nIt will install them into:\n/userdata/system/pro/ and /userdata/roms/ports/\n\nProceed?" 14 60
if [ $? -ne 0 ]; then
    dialog --msgbox "Installation cancelled." 6 30
    exit 1
fi

# Step 1: Create necessary directories
mkdir -p "$EFI_DIR"
mkdir -p "$PORTS_DIR"

# Step 2: Download .dialogrc if missing
if [ ! -f "$DIALOGRC_PATH" ]; then
    dialog --infobox "Downloading .dialogrc for dialog customization..." 5 50
    curl -Ls https://github.com/trashbus99/profork/raw/master/.dep/.dialogrc -o "$DIALOGRC_PATH"
    if [ $? -ne 0 ]; then
        dialog --msgbox "❌ Failed to download .dialogrc" 6 40
        exit 1
    fi
fi

# Step 3: Download efi.sh
dialog --infobox "Downloading efi.sh (main script)..." 5 50
curl -Ls https://github.com/trashbus99/profork/raw/master/scripts/efi.sh -o "$EFI_SCRIPT_PATH"
if [ $? -ne 0 ]; then
    dialog --msgbox "❌ Failed to download efi.sh" 6 40
    exit 1
fi

# Step 4: Make efi.sh executable
chmod +x "$EFI_SCRIPT_PATH"

# Step 5: Download efibootmgr.sh.keys
dialog --infobox "Downloading efibootmgr.sh.keys (gamepad key mappings)..." 5 50
curl -Ls https://github.com/trashbus99/profork/raw/master/app/bkeys.txt -o "$PORTS_KEYS"
if [ $? -ne 0 ]; then
    dialog --msgbox "❌ Failed to download efibootmgr.sh.keys" 6 40
    exit 1
fi

# Step 6: Create efibootmgr.sh launcher in Ports
cat <<EOF > "$PORTS_LAUNCHER"
#!/bin/bash
# EFIBOOTMGR Launcher Script

# Set dialog color file
DIALOGRC="$DIALOGRC_PATH"

# Set display
DISPLAY=:0.0

# Launch efi.sh using xterm with keys file for gamepad control
xterm -fs 20 -maximized -fg white -bg black -fa "DejaVuSansMono" -en UTF-8 \
-e bash -c "DISPLAY=:0.0 DIALOGRC='$DIALOGRC_PATH' bash '$EFI_SCRIPT_PATH'"
EOF

# Step 7: Make launcher executable
chmod +x "$PORTS_LAUNCHER"

# Step 8: Finish
dialog --msgbox "✅ Installation complete!\n\nLauncher created at:\n/userdata/roms/ports/efibootmgr.sh\n\nGamepad keys at:\n/userdata/roms/ports/efibootmgr.sh.keys\n\n⚡ NOTE: Refresh EmulationStation to see the new port!\n(START ➔ GAME SETTINGS ➔ UPDATE GAME LIST)" 16 50

