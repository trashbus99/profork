#!/bin/bash

# Temp file for dialog
TMPFILE=$(mktemp)
trap "rm -f $TMPFILE" EXIT

# Step 1: Get Boot Entries
boot_entries=$(efibootmgr | grep '^Boot[0-9A-Fa-f]*\*' | sed 's/^\(Boot[0-9A-Fa-f]*\)\*\s*/\1 /')

# Step 2: Build dialog menu
menu_items=()
while read -r line; do
    bootnum=$(echo "$line" | awk '{print $1}' | sed 's/^Boot//; s/\*//')
    label=$(echo "$line" | cut -d' ' -f2-)
    menu_items+=("$bootnum" "$label")
done <<< "$boot_entries"

# Exit if no entries
if [ ${#menu_items[@]} -eq 0 ]; then
    dialog --msgbox "No UEFI boot entries found." 10 40
    exit 1
fi

# Step 3: User picks a boot entry
dialog --title "Select Boot Entry" --menu "Choose a boot entry:" 20 60 10 "${menu_items[@]}" 2>"$TMPFILE"
CHOICE=$(<"$TMPFILE")
[ -z "$CHOICE" ] && exit 1

# Step 4: Ask what to do
dialog --title "Boot Option" --menu "Choose what to do:" 15 75 5 \
    "next" "Boot this entry once (safe)" \
    "default" "Change default boot order (manual change in BIOS needed to return!)" \
    "create" "Make a reboot-to-entry launcher in Ports" 2>"$TMPFILE"
MODE=$(<"$TMPFILE")
[ -z "$MODE" ] && exit 1

# Step 5: Do the action
if [ "$MODE" = "next" ]; then
    efibootmgr -n "$CHOICE"
    dialog --msgbox "✅ Set to boot $CHOICE once on next reboot." 8 50

elif [ "$MODE" = "default" ]; then
    efibootmgr -o "$CHOICE"
    dialog --msgbox "⚠️ Boot order permanently changed to $CHOICE.\n\nYou must manually change it back via BIOS, EFIBOOT or BCDEDIT later!" 10 50

elif [ "$MODE" = "create" ]; then
    # --- Create Reboot Script ---
    
    # Ask for friendly name
    dialog --inputbox "Enter a friendly name (e.g., Reboot to Windows):" 10 70 2>"$TMPFILE"
    FRIENDLY_NAME=$(<"$TMPFILE")
    [ -z "$FRIENDLY_NAME" ] && exit 1

    # Ask if one-time or indefinite
    dialog --title "Reboot Type" --menu "Should the reboot be one-time (safe) or indefinitely (UEFI BIOS CHANGE REQUIRED TO RETURN!)?" 15 60 5 \
        "once" "Boot once (safe)" \
        "indefinitely" "Change default permanently (manual fix needed!)" 2>"$TMPFILE"
    REBOOT_TYPE=$(<"$TMPFILE")
    [ -z "$REBOOT_TYPE" ] && exit 1

    # Determine suffix and efibootmgr option
    if [ "$REBOOT_TYPE" = "once" ]; then
        TYPE_SUFFIX="_once"
        EFI_OPTION="-n"
    else
        TYPE_SUFFIX="_indefinitely"
        EFI_OPTION="-o"
    fi

    # Convert friendly name to safe filename
    FILE_NAME=$(echo "$FRIENDLY_NAME" | tr '[:upper:]' '[:lower:]' | tr ' ' '_' | tr -cd '[:alnum:]_-')
    SCRIPT_PATH="/userdata/roms/ports/${FILE_NAME}${TYPE_SUFFIX}.sh"

    # Create the script
    mkdir -p /userdata/roms/ports
    cat <<EOF > "$SCRIPT_PATH"
#!/bin/bash
# Auto-generated reboot script: $FRIENDLY_NAME ($REBOOT_TYPE)
efibootmgr $EFI_OPTION $CHOICE
reboot
EOF

    chmod +x "$SCRIPT_PATH"

    dialog --msgbox "✅ Created reboot script:\n$SCRIPT_PATH\n\nThis will set '$EFI_OPTION $CHOICE' and reboot.\n\n⚡ NOTE: To see it in EmulationStation:\n➔ Press START ➔ GAME SETTINGS ➔ UPDATE GAME LIST" 14 60
fi

# Step 6: Offer to reboot now
dialog --yesno "🔄 Reboot now?" 7 40
if [ $? -eq 0 ]; then
    reboot
else
    dialog --msgbox "You chose not to reboot now.\nYou can reboot manually later." 7 40
fi
