#!/bin/bash

PKGX_DIR="/userdata/pro/pkgx"
PKGX_BIN="$PKGX_DIR/pkgx"
SYMLINK_PATH="/usr/bin/pkgx"
CUSTOM_SH="/userdata/system/custom.sh"

# Create target dir
mkdir -p "$PKGX_DIR"
cd "$PKGX_DIR" || exit 1

# Fetch latest pkgx release for x86-64
echo "Fetching latest pkgx release URL..."
PKGX_URL=$(curl -s https://api.github.com/repos/pkgxdev/pkgx/releases/latest \
  | jq -r '.assets[] | select(.name | endswith("+linux+x86-64.tar.gz")) | .browser_download_url')

if [ -z "$PKGX_URL" ]; then
  echo "Could not find latest pkgx build. Exiting."
  exit 1
fi

FILENAME=$(basename "$PKGX_URL")

# Download if not already present
if [ ! -f "$FILENAME" ]; then
  echo "Downloading $FILENAME..."
  curl -LO "$PKGX_URL"
  echo "Extracting..."
  tar -xf "$FILENAME"
  chmod +x pkgx
  echo "Cleaning up old archives..."
  find . -maxdepth 1 -type f -name "*.tar.*" ! -name "$FILENAME" -delete
else
  echo "Already have latest: $FILENAME"
fi

# Create symlink now
if [ ! -e "$SYMLINK_PATH" ]; then
  echo "Creating symlink: $SYMLINK_PATH -> $PKGX_BIN"
  ln -s "$PKGX_BIN" "$SYMLINK_PATH"
else
  echo "Symlink already exists at $SYMLINK_PATH"
fi

# Ensure persistence via custom.sh
if ! grep -q "$PKGX_BIN" "$CUSTOM_SH" 2>/dev/null; then
  echo "Adding symlink command to $CUSTOM_SH"
  echo "" >> "$CUSTOM_SH"
  echo "# Ensure pkgx is symlinked on boot" >> "$CUSTOM_SH"
  echo "[ -e \"$PKGX_BIN\" ] && ln -sf \"$PKGX_BIN\" \"$SYMLINK_PATH\"" >> "$CUSTOM_SH"
  chmod +x "$CUSTOM_SH"
fi

echo "✅ pkgx is installed and ready to use."
echo "   Symlink will persist after reboot."
