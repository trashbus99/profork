#!/bin/bash

# Set path where .dialogrc should be
DIALOGRC_PATH="/userdata/system/pro/.dialogrc"

# Check if .dialogrc exists, if not, download it
if [ ! -f "$DIALOGRC_PATH" ]; then
    echo "Downloading .dialogrc for dialog color customization..."
    mkdir -p /userdata/system/pro
    curl -Ls https://github.com/trashbus99/profork/raw/master/.dep/.dialogrc -o "$DIALOGRC_PATH"
fi

# Launch the main menu script using xterm with custom dialog colors
DIALOGRC="$DIALOGRC_PATH" \
DISPLAY=:0.0 \
xterm -fs 20 -maximized -fg white -bg black -fa "DejaVuSansMono" -en UTF-8 \
-e bash -c "DISPLAY=:0.0 curl -L https://github.com/trashbus99/profork/raw/master/app/mainmenu.sh | bash"
