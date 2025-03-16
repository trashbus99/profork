#!/usr/bin/env bash
# Script to convert selected Xbox ISOs to xiso format using a temporary directory.

# Check required dependencies: dialog, curl, unzip.
for cmd in dialog curl unzip; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "Error: '$cmd' is not installed. Please install it and rerun."
    exit 1
  fi
done

# Set the ROM directory to scan.
ROM_DIR="/userdata/roms/xbox"

# Verify the directory exists.
if [ ! -d "$ROM_DIR" ]; then
  dialog --msgbox "Directory $ROM_DIR does not exist. Exiting." 6 40
  exit 1
fi

# Create temporary working directory.
WORK_DIR=$(mktemp -d -t iso_conv_XXXXXX)
if [ ! -d "$WORK_DIR" ]; then
  dialog --msgbox "Failed to create temporary directory. Exiting." 6 40
  exit 1
fi

# Prepare temporary files for dialog checklist.
CHECKLIST_FILE=$(mktemp)
DIALOG_OUTPUT=$(mktemp)

# Build checklist entries for each ISO file (include "off" flag).
count=0
for iso in "$ROM_DIR"/*.iso; do
  [ -e "$iso" ] || continue
  iso_name=$(basename "$iso")
  echo "\"$iso\" \"$iso_name\" off" >> "$CHECKLIST_FILE"
  ((count++))
done

if [ $count -eq 0 ]; then
  dialog --msgbox "No ISO files found in $ROM_DIR. Exiting." 6 40
  rm -f "$CHECKLIST_FILE" "$DIALOG_OUTPUT"
  rmdir "$WORK_DIR"
  exit 0
fi

# Let the user select which ISOs to convert.
dialog --separate-output --checklist "Select ISOs to convert:" 20 70 10 --file "$CHECKLIST_FILE" 2> "$DIALOG_OUTPUT"
if [ $? -ne 0 ]; then
  dialog --msgbox "No selection made. Exiting." 6 40
  rm -f "$CHECKLIST_FILE" "$DIALOG_OUTPUT"
  rmdir "$WORK_DIR"
  exit 1
fi

rm -f "$CHECKLIST_FILE"

# Ensure extract-xiso is available.
EXTRACT_XISO_BIN="/tmp/extract-xiso"
if ! command -v extract-xiso &>/dev/null && [ ! -f "$EXTRACT_XISO_BIN" ]; then
  dialog --infobox "Downloading extract-xiso tool..." 5 50
  EXTRACT_XISO_URL="https://github.com/XboxDev/extract-xiso/releases/download/build-202501282328/extract-xiso_Linux.zip"
  curl -L -o "/tmp/extract-xiso.zip" "$EXTRACT_XISO_URL"
  unzip -o "/tmp/extract-xiso.zip" -d /tmp/
  chmod +x "$EXTRACT_XISO_BIN"
  rm -f "/tmp/extract-xiso.zip"
fi

# Process each selected ISO (each line from DIALOG_OUTPUT).
while IFS= read -r iso; do
  # Remove any surrounding quotes.
  iso=$(echo "$iso" | sed 's/^"//; s/"$//')
  iso_name=$(basename "$iso")
  
  dialog --title "Converting ISO" --infobox "Processing $iso_name..." 5 50

  # Copy the ISO to the temporary work directory.
  cp "$iso" "$WORK_DIR/"
  if [ $? -ne 0 ]; then
    dialog --msgbox "Failed to copy $iso_name to temporary directory. Skipping." 6 50
    continue
  fi

  WORK_ISO="${WORK_DIR}/${iso_name}"
  
  # Create a temporary extraction folder within the work directory.
  extract_folder="${WORK_DIR}/extracted_${iso_name}"
  mkdir -p "$extract_folder"
  
  # Extract the ISO.
  "$EXTRACT_XISO_BIN" -x "$WORK_ISO" -d "$extract_folder"
  
  if [ -d "$extract_folder" ] && [ "$(ls -A "$extract_folder")" ]; then
    dialog --title "Rebuilding ISO" --infobox "Rebuilding $iso_name..." 5 50
    "$EXTRACT_XISO_BIN" -c "$extract_folder" "${WORK_ISO}_fixed.iso"
    
    if [ -f "${WORK_ISO}_fixed.iso" ]; then
      # Backup original ISO.
      mv "$iso" "${iso}.old"
      # Move the fixed ISO back to the original directory.
      mv "${WORK_ISO}_fixed.iso" "$iso"
      rm -rf "$extract_folder"
      # Remove the temporary copy.
      rm -f "$WORK_ISO"
    else
      dialog --msgbox "Failed to rebuild $iso_name! Keeping original ISO." 6 50
      rm -rf "$extract_folder"
      rm -f "$WORK_ISO"
    fi
  else
    dialog --msgbox "Failed to extract $iso_name! Keeping original ISO." 6 50
    rm -rf "$extract_folder"
    rm -f "$WORK_ISO"
  fi
done < "$DIALOG_OUTPUT"

# Clean up the temporary working directory.
rm -rf "$WORK_DIR"
rm -f "$DIALOG_OUTPUT"

dialog --msgbox "Conversion complete!" 6 40
clear
exit 0
