#!/bin/bash

# Set path where .dialogrc should be
DIALOGRC_PATH="/userdata/system/add-ons/.dialogrc"
SPLASH_PATH="/userdata/system/add-ons/b.mp4"
SPLASH_URL="https://github.com/trashbus99/profork/releases/download/r1/b.mp4"

# Ensure the add-ons directory exists
mkdir -p /userdata/system/add-ons

# Download .dialogrc if missing
if [ ! -f "$DIALOGRC_PATH" ]; then
    echo "Downloading .dialogrc for dialog color customization..."
    curl -Ls https://github.com/trashbus99/profork/raw/master/.dep/.dialogrc -o "$DIALOGRC_PATH"
fi

# Download splash video if missing
if [ ! -f "$SPLASH_PATH" ]; then
    echo "Downloading BUA Sunbaby splash video..."
    curl -Ls "$SPLASH_URL" -o "$SPLASH_PATH"
fi

# Play splash video with cvlc
if command -v cvlc >/dev/null 2>&1; then
    cvlc --play-and-exit --no-video-title-show --no-video-deco --no-embedded-video "$SPLASH_PATH"
    clear
fi

# Launch the original BUA installer using xterm
DIALOGRC="$DIALOGRC_PATH" \
DISPLAY=:0.0 \
xterm -fs 20 -maximized -fg white -bg black -fa "DejaVuSansMono" -en UTF-8 \
-e bash -c "DISPLAY=:0.0 curl -Ls https://github.com/DTJW92/batocera-unofficial-addons/raw/main/app/batocera-unofficial-addons-arm64.sh | bash"
