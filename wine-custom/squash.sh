#!/bin/bash
# Script to compress a .wine folder (found in /userdata/roms/windows) using either TGZ or SquashFS.
# It lists only folders ending in .wine, allows the user to select one, and then asks for the
# compression method. After the conversion is complete, the output file is renamed to remove the ".wine"
# portion and the user is offered the option to compress another folder.
#
# Requirements:
#   - dialog must be installed.
#   - batocera-wine must be available.

# Check if dialog is installed
if ! command -v dialog &> /dev/null; then
  echo "The 'dialog' command is required but not installed. Aborting."
  exit 1
fi

while true; do
  # --- STEP 1: Find all .wine folders in /userdata/roms/windows ---
  wine_folders=()
  for dir in /userdata/roms/windows/*.wine; do
    [ -d "$dir" ] || continue
    wine_folders+=( "$dir" "" )
  done

  if [ ${#wine_folders[@]} -eq 0 ]; then
    dialog --msgbox "No .wine folders found in /userdata/roms/windows." 10 40
    exit 1
  fi

  # --- STEP 2: Let the user select a .wine folder ---
  selected_wine=$(dialog --clear --title ".wine Folder Selection" \
    --menu "Select a .wine folder to compress:" 15 90 6 "${wine_folders[@]}" 3>&1 1>&2 2>&3)
  exit_status=$?
  clear
  if [ $exit_status -ne 0 ]; then
    echo "Cancelled."
    exit 1
  fi

  # --- STEP 3: Ask for Compression Method ---
  compression_choice=$(dialog --clear --title "Select Compression Type" \
    --menu "Choose compression method for:\n$selected_wine" 12 70 2 \
    "wtgz" "TGZ - repackages quickly, best for small games with large writes" \
    "wsquashfs" "SquashFS - best for larger games with small writes" 3>&1 1>&2 2>&3)
  exit_status=$?
  clear
  if [ $exit_status -ne 0 ]; then
    echo "Cancelled."
    exit 1
  fi


  # --- STEP 4: Run the appropriate compression command ---
  export DISPLAY=:0.0
  case "$compression_choice" in
    wtgz)
      dialog --infobox "Converting folder to TGZ format (wtgz)... Please wait." 8 60
      batocera-wine windows wine2winetgz "$selected_wine"
      # Assume the output file is created as: selected_wine.tgz
      old_output="${selected_wine}.tgz"
      final_output="${selected_wine%.wine}.tgz"
      if [ -f "$old_output" ]; then
        mv "$old_output" "$final_output"
        dialog --msgbox "TGZ compression complete!\nOutput file:\n$final_output" 10 50
      else
        dialog --msgbox "Error creating TGZ image." 10 40
      fi
      ;;
    wsquashfs)
      dialog --infobox "Converting folder to SquashFS format (wsquashfs)... Please wait." 8 60
      batocera-wine windows wine2squashfs "$selected_wine"
      # Assume the output file is created as: selected_wine.wsquashfs
      old_output="${selected_wine}.wsquashfs"
      final_output="${selected_wine%.wine}.wsquashfs"
      if [ -f "$old_output" ]; then
        mv "$old_output" "$final_output"
        dialog --msgbox "SquashFS compression complete!\nOutput file:\n$final_output" 10 50
      else
        dialog --msgbox "Error creating SquashFS image." 10 40
      fi
      ;;
    *)
      dialog --msgbox "Invalid compression option selected." 10 40
      ;;
  esac

  # --- STEP 5: Ask if the user wants to process another folder ---
  dialog --yesno "Do you want to compress another .wine folder?" 8 40
  if [ $? -ne 0 ]; then
    clear
    exit 0
  fi
  clear
done
echo "returning to wine tools menu"
sleep 2
curl -L https://github.com/trashbus99/profork/raw/master/wine-custom/wine.sh | bash
