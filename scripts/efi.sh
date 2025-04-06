#!/bin/bash

# Set up a temp file for dialog output
TMPFILE=$(mktemp)

# Trap to clean up temp file on exit
trap "rm -f $TMPFILE" EXIT

# Step 1: Get Boot Entries
boot_entries=$(efibootmgr | grep '^Boot[0-9A-Fa-f]*\*' | sed 's/^\(Boot[0-9A-Fa-f]*\)\*\s*/\1 /')

# Step 2: Build dialog menu
menu_items=()
while read -r line; do
    bootnum=$(echo "$line" | awk '{print $1}' | sed 's/[^0-9A-Fa-f]//g')
    label=$(echo "$line" | cut -d' ' -f2-)
    menu_items+=("$bootnum" "$label")
done <<< "$boot_entries"

# If no entries, exit
if [ ${#menu_items[@]} -eq 0 ]; then
    dialog --msgbox "No UEFI boot entries found." 10 40
    exit 1
fi

# Step 3: Ask user to pick a boot entry
dialog --title "Select Boot Entry" --menu "Choose a boot entry:" 30 75 10 "${menu_items[@]}" 2>"$TMPFILE"
CHOICE=$(<"$TMPFILE")

# If user cancels
[ -z "$CHOICE" ] && exit 1

# Step 4: Ask if one-time reboot (-n) or permanent change (-o)
dialog --title "Boot Option" --menu "How do you want to reboot?" 15 75 5 \
    "next" "Boot this entry once (safe)" \
    "default" "Change default boot order (indefinitely)" 2>"$TMPFILE"
MODE=$(<"$TMPFILE")

[ -z "$MODE" ] && exit 1

# Step 5: Act based on choice
if [ "$MODE" = "next" ]; then
    efibootmgr -n "$CHOICE"
    dialog --msgbox "Set to boot $CHOICE once on next reboot." 8 40
else
    efibootmgr -o "$CHOICE"
    dialog --msgbox "Boot order set to $CHOICE permanently.\n\nYou must manually change it back via BIOS or Linux later!" 10 50
fi

# Step 6: Offer to reboot now
dialog --yesno "Reboot now?" 7 30
if [ $? -eq 0 ]; then
    reboot
else
    dialog --msgbox "Done. Reboot later manually." 6 30
fi
