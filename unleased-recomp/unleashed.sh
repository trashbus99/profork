#!/bin/bash
set -e

# Ensure the Flathub remote is added for dependency resolution
echo "Ensuring Flathub remote is added..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Specify the release tag and API URL
RELEASE_TAG="v1.0.2"
GITHUB_API_URL="https://api.github.com/repos/hedge-dev/UnleashedRecomp/releases/tags/${RELEASE_TAG}"
echo "Fetching release information for ${RELEASE_TAG} from GitHub..."

# Retrieve release JSON data
RELEASE_INFO=$(curl -s "$GITHUB_API_URL")

# Extract the download URL for the asset that contains "Flatpak" in its name and ends with ".zip"
DOWNLOAD_URL=$(echo "$RELEASE_INFO" | jq -r '.assets[] | select(.name | contains("Flatpak") and endswith(".zip")) | .browser_download_url' | tr -d '\r\n')

if [[ -z "$DOWNLOAD_URL" ]]; then
    echo "Error: Could not retrieve a release URL for a zip file with 'Flatpak' in its name."
    exit 1
fi

echo "Download URL: $DOWNLOAD_URL"

# Use the basename of the URL as the local filename
ZIP_FILE=$(basename "$DOWNLOAD_URL")
EXTRACT_DIR="UnleashedRecomp"

# Download the asset
echo "Downloading Unleashed Recomp release ${RELEASE_TAG}..."
curl -L --fail "$DOWNLOAD_URL" -o "$ZIP_FILE"

if [[ ! -f "$ZIP_FILE" ]]; then
    echo "Error: Failed to download the release."
    exit 1
fi

# Remove any previous extraction directory
rm -rf "$EXTRACT_DIR"

# Extract the downloaded zip file
echo "Extracting Unleashed Recomp..."
unzip -o "$ZIP_FILE" -d "$EXTRACT_DIR"

# Locate the Flatpak file within the extracted directory
FLATPAK_FILE=$(find "$EXTRACT_DIR" -type f -name "*.flatpak" | head -n 1)
if [[ -z "$FLATPAK_FILE" ]]; then
    echo "Error: No Flatpak file found in the extracted directory."
    exit 1
fi

# Install the Flatpak package in user mode
echo "Installing Unleashed Recomp via Flatpak..."
flatpak install --user --noninteractive "$FLATPAK_FILE"

# Cleanup temporary files
echo "Cleaning up..."
rm -rf "$ZIP_FILE" "$EXTRACT_DIR"

echo "Installation complete!"

# Show a dialog message with details about Sonic Unleashed for Xbox 360
dialog --title "Installation Successful" --msgbox "Sonic Unleashed for Xbox 360 (US or EU, JP is not supported)
Retail Disc or Digital Copy (can be purchased and downloaded from the Xbox Store) &
Title Update required.
All available DLC (Adventure Packs) are optional, but highly recommended. The DLC includes high quality lighting for the entire game.
See GitHub page for more information." 15 80

# Clear the dialog from the terminal after key press
clear
