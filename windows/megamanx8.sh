#!/bin/bash
set -e

# Variables
ZIP_URL="https://sonicfangameshq.com/forums/dl-attach.php?uri=attachments/mega-man-x8-16-bit-zip.34634/"
TMP_DIR=$(mktemp -d)
ZIP_FILE="$TMP_DIR/megaman.zip"
DEST_DIR="/userdata/roms/windows/megamanx8.pc"
AUTORUN_FILE="$DEST_DIR/autorun.cmd"
EXECUTABLE_NAME="Mega Man X8 16-bit 1.0.0.9.exe"
DIALOG_TITLE="Information"
DIALOG_MSG="If game crashes adjusting screen sizes, try a different wine runner.\nSuccessfully tested using Wine 10.0 from wine custom downloader."

# Create destination directory if it does not exist
mkdir -p "$DEST_DIR"

# Download the zip file with curl (progress bar enabled)
echo "Downloading zip file..."
curl -L --progress-bar -o "$ZIP_FILE" "$ZIP_URL"

# Unzip the downloaded file to destination directory
echo "Extracting zip file to $DEST_DIR..."
unzip -q "$ZIP_FILE" -d "$DEST_DIR"

# Remove the temporary directory and its contents
echo "Cleaning up temporary files..."
rm -rf "$TMP_DIR"

# Create autorun.cmd file with the required command, quoting the executable name
echo "Creating autorun.cmd..."
echo "CMD=\"$EXECUTABLE_NAME\"" > "$AUTORUN_FILE"

# Show dialog message
dialog --title "$DIALOG_TITLE" --msgbox "$DIALOG_MSG" 10 60

echo "Done."
