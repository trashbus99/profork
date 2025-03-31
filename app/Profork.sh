#!/bin/bash

# Set path where .dialogrc should be
DIALOGRC_PATH="/userdata/system/pro/.dialogrc"
SPLASH_PATH="/userdata/system/pro/pf.mp4"
SPLASH_URL="https://github.com/trashbus99/profork/raw/master/.dep/pf.mp4"

# Ensure the pro directory exists
mkdir -p /userdata/system/pro

# Download .dialogrc if missing
if [ ! -f "$DIALOGRC_PATH" ]; then
    echo "Downloading .dialogrc for dialog color customization..."
    curl -Ls https://github.com/trashbus99/profork/raw/master/.dep/.dialogrc -o "$DIALOGRC_PATH"
fi

# Download splash video if missing
if [ ! -f "$SPLASH_PATH" ]; then
    echo "Downloading Profork splash video..."
    curl -Ls "$SPLASH_URL" -o "$SPLASH_PATH"
fi

# Play splash video with cvlc
if command -v cvlc >/dev/null 2>&1; then
    cvlc --play-and-exit --no-video-title-show --no-video-deco --no-embedded-video "$SPLASH_PATH"
    clear
fi

# Launch the main menu script using xterm with custom dialog colors
DIALOGRC="$DIALOGRC_PATH" \
DISPLAY=:0.0 \
xterm -fs 20 -maximized -fg white -bg black -fa "DejaVuSansMono" -en UTF-8 \
-e bash -c "DISPLAY=:0.0 curl -Ls https://github.com/trashbus99/profork/raw/master/app/mainmenu.sh | bash"
