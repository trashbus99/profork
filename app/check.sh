#!/bin/bash

PORTS_LAUNCHER="/userdata/roms/ports/Profork.sh"
SPLASH_MP4="/userdata/system/pro/pf.mp4"
INSTALL_URL="https://github.com/trashbus99/profork/raw/master/app/install.sh"

# Check if either the launcher or splash video is missing
if [ ! -f "$PORTS_LAUNCHER" ] || [ ! -f "$SPLASH_MP4" ]; then
    echo "Profork not fully installed. Running installer..."
    curl -Ls "$INSTALL_URL" | bash

    # Re-check and confirm
    if [ -f "$PORTS_LAUNCHER" ] && [ -f "$SPLASH_MP4" ]; then
        echo "✅ Installed Profork launcher and splash video."
    else
        echo "❌ Installation failed or incomplete. Check your network or GitHub link."
    fi
else
    echo "✅ Profork is already fully installed."
fi
