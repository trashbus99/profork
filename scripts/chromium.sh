#!/bin/bash

# Define key directories and files
CHROOT_DIR="/userdata/system/alpine"
LAUNCH_SCRIPT_DIR="/userdata/roms/ports"
APK_CACHE_DIR="/userdata/apk-cache"
#!/bin/bash
# --- Define directories ---
CHROOT_DIR="/userdata/system/alpine"
LAUNCH_SCRIPT_DIR="/userdata/roms/ports"

# --- Function to check if Alpine chroot is installed ---
install_alpine_chroot() {
    echo "🔍 Checking if Alpine chroot is already installed..."
    if [ -d "$CHROOT_DIR" ] && [ -f "$CHROOT_DIR/bin/busybox" ]; then
        echo "✅ Alpine chroot detected. Skipping installation."
    else
        echo "🚀 Installing Alpine chroot..."
        curl -L https://github.com/trashbus99/profork/raw/master/scripts/alpine.sh | bash
    fi
}

# --- Function to update repositories and install Chromium ---
install_chromium() {
    echo "🌍 Updating Alpine package sources and installing Chromium..."
    chroot "$CHROOT_DIR" /bin/bash -l <<'EOF'
apk update
apk add nano
echo "🔧 Editing repositories file..."
sed -i 's|^http.*|# Disabled Default Repo|' /etc/apk/repositories
echo "https://dl-cdn.alpinelinux.org/alpine/v3.21/main" > /etc/apk/repositories
echo "https://dl-cdn.alpinelinux.org/alpine/v3.21/community" >> /etc/apk/repositories
apk update && apk upgrade
apk add chromium
EOF
}

# --- Install Alpine chroot (if needed) and update repositories/install Chromium ---
install_alpine_chroot
install_chromium

echo "🎉 Alpine chroot setup complete!"

# --- Create launch script directory ---
mkdir -p "$LAUNCH_SCRIPT_DIR"

# --- Function to generate launcher scripts and accompanying pad2key config ---
create_launcher() {
    local script_name="$1"
    local url="$2"
    local mode="$3"
    local launcher_path="$LAUNCH_SCRIPT_DIR/$script_name"
    local keys_path="$launcher_path.keys"
    local launch_command=""

    if [ "$mode" = "kiosk" ]; then
        launch_command="/usr/bin/chromium --no-sandbox --enable-gamepad --kiosk --start-fullscreen \"$url\""
    else
        launch_command="/usr/bin/chromium --no-sandbox --enable-gamepad \"$url\""
    fi

    cat > "$launcher_path" <<EOF
#!/bin/bash
# Set chroot location and use DISPLAY=:0.0 (for XWayland)
CHROOT_DIR="$CHROOT_DIR"
DISPLAY=:0.0

# Launch Chromium in the chroot with gamepad support enabled.
exec chroot "\$CHROOT_DIR" env DISPLAY=\$DISPLAY $launch_command
EOF

    chmod +x "$launcher_path"
    echo "✅ Created launcher: $launcher_path"

    # Create the accompanying pad2key configuration file
    cat > "$keys_path" <<EOF
{
    "actions_player1": [
        {
            "trigger": ["hotkey", "start"],
            "type": "key",
            "target": ["KEY_LEFTALT", "KEY_F4"],
            "description": "Press Alt+F4"
        }
    ]
}
EOF
    echo "✅ Created pad2key config: $keys_path"
}

# --- Create specific launchers ---
create_launcher "chroot-chromium-spotify.sh" "https://open.spotify.com/" "kiosk"
create_launcher "chroot-chromium-geforcenow.sh" "https://play.geforcenow.com/" "kiosk"
create_launcher "chroot-chromium-amazonluna.sh" "https://luna.amazon.com/" "kiosk"
create_launcher "chroot-chromium-xcloud.sh" "https://www.xbox.com/en-us/play" "kiosk"
create_launcher "chroot-chromium.sh" "https://google.com" "window"

echo "✅ All launchers and pad2key configs created successfully!"
echo "ROCKSHIP SOC devices need panfrost drivers enabled"
echo "Select+Start Kills chromium"

# Ensure Alpine chroot exists; if not, install it.
if [ ! -d "$CHROOT_DIR" ] || [ ! -f "$CHROOT_DIR/bin/busybox" ]; then
    echo "🟡 Alpine chroot not found. Installing..."
    curl -Ls https://github.com/trashbus99/profork/raw/master/scripts/alpine.sh | bash
fi

# Ensure APK cache directory exists and is used
mkdir -p "$APK_CACHE_DIR"
chroot "$CHROOT_DIR" /bin/sh -c "echo '$APK_CACHE_DIR' > /etc/apk/cache"

# Bind necessary directories to keep writes within /userdata
mkdir -p "$CHROOT_DIR/var/tmp"
mkdir -p "$CHROOT_DIR/var/cache"
mount --bind "$CHROOT_DIR/var/tmp" "$CHROOT_DIR/var/tmp"
mount --bind "$CHROOT_DIR/var/cache" "$CHROOT_DIR/var/cache"

# Install Chromium inside the chroot
echo "🟡 Installing Chromium inside chroot..."
chroot "$CHROOT_DIR" /bin/sh -c "apk update && apk add --no-cache chromium"

# Create the launch script directory if it doesn't exist.
mkdir -p "$LAUNCH_SCRIPT_DIR"

# Function to generate a launcher script and accompanying pad2key file.
# Arguments:
#   1) Script filename
#   2) URL to open
#   3) Mode: "kiosk" for kiosk/fullscreen mode or "window" for regular mode.
create_launcher() {
    local script_name="$1"
    local url="$2"
    local mode="$3"
    local launcher_path="$LAUNCH_SCRIPT_DIR/$script_name"
    local keys_path="$launcher_path.keys"
    local launch_command=""

    if [ "$mode" = "kiosk" ]; then
        launch_command="/usr/bin/chromium --no-sandbox --enable-gamepad --kiosk --start-fullscreen \"$url\""
    else
        launch_command="/usr/bin/chromium --no-sandbox --enable-gamepad \"$url\""
    fi

    cat > "$launcher_path" <<EOF
#!/bin/bash
# Define chroot and environment variables.
CHROOT_DIR="$CHROOT_DIR"
DISPLAY=:0.0

# Launch Chromium in the chroot with gamepad support enabled.
exec chroot "\$CHROOT_DIR" env \\
    DISPLAY=\$DISPLAY \\
    $launch_command
EOF

    chmod +x "$launcher_path"
    echo "✅ Created launcher: $launcher_path"

    # Create pad2key configuration file
    cat > "$keys_path" <<EOF
{
    "actions_player1": [
        {
            "trigger": ["hotkey", "start"],
            "type": "key",
            "target": ["KEY_LEFTALT", "KEY_F4"],
            "description": "Press Alt+F4"
        }
    ]
}
EOF
    echo "✅ Created pad2key config: $keys_path"
}

# Create kiosk-mode launchers for specific websites.
create_launcher "chroot-chromium-spotify.sh" "https://open.spotify.com/" "kiosk"
create_launcher "chroot-chromium-geforcenow.sh" "https://play.geforcenow.com/" "kiosk"
create_launcher "chroot-chromium-amazonluna.sh" "https://luna.amazon.com/" "kiosk"
create_launcher "chroot-chromium-xcloud.sh" "https://www.xbox.com/en-us/play" "kiosk"

# Create a general Chromium launcher (non-kiosk, windowed mode) with Google as the home page.
create_launcher "chroot-chromium.sh" "https://google.com" "window"

echo "✅ All launchers and pad2key configs created successfully!"
echo "ROCKSHIP SOC devices need panfrost drivers enabled"
echo "Select+Start Kills chromium"
