#!/bin/bash 


BASE_DIR="/userdata/roms/ps3"
SCRIPT_URL="https://raw.githubusercontent.com/trashbus99/profork/master/scripts/rpcs3/batocera-rpcs3-sync"
SCRIPT_PATH="/userdata/system/batocera-rpcs3-sync"
TROPHY_URL="https://github.com/trashbus99/profork/raw/master/scripts/snd_trophy.wav"
TROPHY_DIR="/userdata/system/configs/rpcs3/sounds"
TROPHY_PATH="$TROPHY_DIR/snd_trophy.wav"

# Check for required tools
for cmd in dialog mksquashfs unsquashfs wget; do
  if ! command -v "$cmd" &>/dev/null; then
    echo "Missing required tool: $cmd"
    exit 1
  fi
done

# Change to the base directory
cd "$BASE_DIR" || { echo "Cannot access PS3 folder: $BASE_DIR"; exit 1; }

# Main Menu
MODE=$(dialog --clear --title "PS3 Manager" \
  --menu "Choose an operation:" 15 60 5 \
  compress   "Compress .ps3 folders to .squashfs (one-by-one)" \
  decompress "Decompress .squashfs images to folders" \
  trophy     "Download trophy sound for RPCS3" \
  psn        "Run PSN parser (auto deletes after run)" \
  exit       "Exit script" \
  3>&1 1>&2 2>&3)
clear

case "$MODE" in
  compress)
    while true; do
      # Enable nullglob so the glob expands to nothing if no match
      shopt -s nullglob
      GAMES=()
      # Build an array of directories ending with .ps3
      for d in *.ps3; do
        if [ -d "$d" ]; then
          GAMES+=( "$d" )
        fi
      done

      # If no folders found, inform and exit the loop
      if [ ${#GAMES[@]} -eq 0 ]; then
        dialog --msgbox "No .ps3 folders found in $BASE_DIR!" 10 50
        break
      fi

      # Build menu options for the available folders
      OPTIONS=()
      for game in "${GAMES[@]}"; do
         OPTIONS+=( "$game" "$game" )
      done

      SELECTED=$(dialog --clear --menu "Select a folder to compress (Cancel to exit):" 15 60 10 "${OPTIONS[@]}" 3>&1 1>&2 2>&3)
      clear

      # If nothing is selected, exit the loop
      [ -z "$SELECTED" ] && break

      BASENAME="${SELECTED%.ps3}"
      dialog --infobox "Compressing: $SELECTED" 5 50

      # Compress using full paths
      mksquashfs "$BASE_DIR/$SELECTED" "$BASE_DIR/${BASENAME}.squashfs" -no-progress

      dialog --msgbox "'$SELECTED' compressed to '${BASENAME}.squashfs'." 8 50
    done
    ;;
  decompress)
    # Enable nullglob so that if no matches are found, the glob returns nothing
    shopt -s nullglob
    # Build an array of files ending with .squashfs
    IMAGES=( *.squashfs )
    if [ ${#IMAGES[@]} -eq 0 ]; then
      dialog --msgbox "No .squashfs files found in $BASE_DIR!" 10 50
      exit 0
    fi

    OPTIONS=()
    for img in "${IMAGES[@]}"; do
      OPTIONS+=( "$img" "$img" "off" )
    done

    SELECTED=$(dialog --clear --checklist "Select images to decompress:" 20 60 15 "${OPTIONS[@]}" --separate-output 3>&1 1>&2 2>&3)
    clear

    if [ -z "$SELECTED" ]; then
      dialog --msgbox "No images selected." 10 50
      exit 0
    fi

    # Convert the multi-line output into an array using a while-read loop
    selectedArray=()
    while IFS= read -r line; do
      selectedArray+=( "$line" )
    done <<< "$SELECTED"

    for img in "${selectedArray[@]}"; do
      # Clean up input: remove carriage returns and strip surrounding quotes
      CLEAN_IMAGE=$(echo "$img" | tr -d '\r' | sed 's/^"\(.*\)"$/\1/')
      BASENAME="${CLEAN_IMAGE%.squashfs}"
      dialog --infobox "Decompressing: $CLEAN_IMAGE" 5 50
      # Check if the file exists before decompressing
      if [ ! -f "$BASE_DIR/$CLEAN_IMAGE" ]; then
        dialog --msgbox "File not found: $BASE_DIR/$CLEAN_IMAGE" 10 50
        continue
      fi
      mkdir -p "$BASE_DIR/$BASENAME"
      unsquashfs -d "$BASE_DIR/$BASENAME" "$BASE_DIR/$CLEAN_IMAGE"
      dialog --msgbox "'$CLEAN_IMAGE' decompressed to folder '$BASENAME'." 8 50
    done

    dialog --msgbox "All selected images have been successfully decompressed." 8 50
    ;;
  trophy)
    # Create target directory if it doesn't exist
    if [ ! -d "$TROPHY_DIR" ]; then
      mkdir -p "$TROPHY_DIR"
    fi

    dialog --infobox "Downloading trophy sound..." 5 50
    wget "$TROPHY_URL" -O "$TROPHY_PATH"
    if [ $? -ne 0 ]; then
      dialog --msgbox "Trophy sound download failed. Check your connection." 10 50
      exit 1
    fi

    chmod 644 "$TROPHY_PATH"
    dialog --msgbox "Trophy sound downloaded successfully to:\n$TROPHY_PATH" 10 50
    ;;
  psn)
    echo "Profork PS3 PSN game parser"
    echo "Thanks to uureel"
    sleep 3
    clear

    echo "Downloading batocera-rpcs3-sync to /userdata/system..."
    wget "$SCRIPT_URL" -O "$SCRIPT_PATH"
    if [ $? -ne 0 ]; then
      dialog --msgbox "Download failed. Check your connection." 10 50
      exit 1
    fi

    chmod +x "$SCRIPT_PATH"
    "$SCRIPT_PATH"
    rm -f "$SCRIPT_PATH"

    dialog --msgbox "batocera-rpcs3-sync has finished and was removed." 10 50
    ;;
  exit)
    clear
    exit 0
    ;;
esac

clear
exit 0
