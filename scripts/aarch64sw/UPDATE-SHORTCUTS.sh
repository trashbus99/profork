#!/bin/bash

# Directory where Switch ROMs are stored
roms_dir="/userdata/roms/switch"

# Enable extended globbing for safer filename handling
shopt -s nullglob nocaseglob

# Default .keys content for `pad2key`
keys_content='{
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
        }
    ]
}'

# Find all supported ROM files in the Switch ROMs directory (assuming .nsp and .xci)
find "$roms_dir" -type f \( -iname "*.nsp" -o -iname "*.xci" \) | while read -r file_path; do
    # Get base filename without extension
    file_name=$(basename "$file_path")
    base_name="${file_name%.*}"

    # Sanitize the filename: replace spaces with underscores and remove unwanted characters
    sanitized_name=$(echo "$base_name" | tr ' ' '_' | tr -cd '[:alnum:]_-')

    # Define paths for Citra and Ryujinx shortcut scripts and their .keys files
    citra_script_path="$roms_dir/${sanitized_name}.Citra.sh"
    citra_keys_path="$roms_dir/${sanitized_name}.Citra.sh.keys"
    ryujinx_script_path="$roms_dir/${sanitized_name}.Ryujinx.sh"
    ryujinx_keys_path="$roms_dir/${sanitized_name}.Ryujinx.sh.keys"

    # Create the Citra shortcut script (launches with -f -g for fullscreen)
    cat << EOF > "$citra_script_path"
#!/bin/bash
batocera-mouse show
DISPLAY=:0.0 "/userdata/system/pro/switch/citra.AppImage" --appimage-extract-and-run -f -g "$file_path"
batocera-mouse hide
EOF

    # Create the Ryujinx shortcut script (launches with --fullscreen)
    cat << EOF > "$ryujinx_script_path"
#!/bin/bash
batocera-mouse show
DISPLAY=:0.0 "/userdata/system/pro/Ryujinx.AppImage" --appimage-extract-and-run --fullscreen "$file_path"
batocera-mouse hide
EOF

    # Make both scripts executable
    chmod +x "$citra_script_path" "$ryujinx_script_path"

    # Create the .keys file for Citra
    echo "$keys_content" > "$citra_keys_path"

    # Create the .keys file for Ryujinx
    echo "$keys_content" > "$ryujinx_keys_path"

    echo "Shortcut created: $citra_script_path"
    echo "Keys file created: $citra_keys_path"
    echo "Shortcut created: $ryujinx_script_path"
    echo "Keys file created: $ryujinx_keys_path"
done

# Restart EmulationStation to apply changes
killall -9 emulationstation
