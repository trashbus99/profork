#!/bin/bash

# Set up display for Batocera
export DISPLAY=:0.0
batocera-mouse show

# Define paths
LIBREWOLF_APPIMAGE="/userdata/system/pro/librewolf/librewolf.AppImage"
XMCL_APPIMAGE="/userdata/system/pro/xmcl/xmcl.AppImage"
DEP_PATH="/userdata/system/pro/.dep"

# Create a fake xdg-open in /tmp so Minecraft uses it for web authentication
export XDG_OPEN_PATH="/tmp/xdg-open"
cat > "$XDG_OPEN_PATH" << 'EOF'
#!/bin/bash
LIBREWOLF_APPIMAGE="/userdata/system/pro/librewolf/librewolf.AppImage"

if echo "$1" | grep -qE '^https?://'; then
    "$LIBREWOLF_APPIMAGE" --appimage-extract-and-run "$1"
else
    echo "xdg-open: Unsupported input: $1"
fi
EOF

# Make it executable
chmod +x "$XDG_OPEN_PATH"

# Export PATH so XMCL finds our custom xdg-open first
export PATH="/tmp:$PATH"

# Launch XMCL
LD_LIBRARY_PATH="$DEP_PATH:${LD_LIBRARY_PATH}" DISPLAY=:0.0 "$XMCL_APPIMAGE" --appimage-extract-and-run --no-sandbox "$@"
