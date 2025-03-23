#!/bin/bash
# Script to run Batocera Wine winetricks on a selected .wine folder.
# It scans for .wine folders in both /userdata/system/wine-bottles and /userdata/roms/windows,
# then offers to install common VC++/DirectX dependencies and additional winetricks packages.
#
# Requirements:
#   - dialog must be installed.
#   - curl must be available for fetching the full winetricks list.
#   - batocera-wine must be available.
#
# WARNING: Ensure you have backups as needed. This script executes winetricks commands via batocera-wine.

# Ensure dialog is installed.
if ! command -v dialog &> /dev/null; then
  echo "The 'dialog' command is required but not installed. Aborting."
  exit 1
fi

while true; do
  # --- STEP 1: Find all .wine folders in /userdata/system/wine-bottles and /userdata/roms/windows ---
  wine_folders=()
  
  # Scan /userdata/system/wine-bottles recursively.
  while IFS= read -r folder; do
    wine_folders+=( "$folder" "" )
  done < <(find /userdata/system/wine-bottles -type d -name "*.wine")
  
  # Also scan /userdata/roms/windows for .wine folders.
  for dir in /userdata/roms/windows/*.wine; do
    [ -d "$dir" ] || continue
    wine_folders+=( "$dir" "" )
  done
  
  if [ ${#wine_folders[@]} -eq 0 ]; then
    dialog --msgbox "No .wine folders found." 10 40
    exit 1
  fi
  
  # --- STEP 2: Let the user select a wine bottle folder ---
  selected_wine=$(dialog --clear --title "Select Wine Bottle" \
    --menu "Choose a .wine folder to apply winetricks:" 15 80 6 "${wine_folders[@]}" 3>&1 1>&2 2>&3)
  exit_status=$?
  clear
  if [ $exit_status -ne 0 ]; then
    echo "Cancelled."
    exit 1
  fi
  
  # --- STEP 3: Prompt for Common VC++/DirectX Dependencies ---
  COMMON_WT=""
  dialog --yesno "VC++/DirectX Dependencies\n\nDo you want to install common VC++ runtimes and DirectX9 (d3dx9_43)?\n\nThese include VC++ 2008, 2010, 2012, 2013, and 2015-2022." 12 60
  if [ $? -eq 0 ]; then
      COMMON_WT=$(dialog --stdout --checklist "Select VC++/DirectX dependencies to install:" 15 60 8 \
          "vcrun2008" "Visual C++ 2008" off \
          "vcrun2010" "Visual C++ 2010" off \
          "vcrun2012" "Visual C++ 2012" off \
          "vcrun2013" "Visual C++ 2013" off \
          "vcrun2022" "Visual C++ 2015-2022" off \
          "d3dx9_43" "DirectX9 (d3dx9_43)" off)
  fi
  
  # --- STEP 4: Prompt for Additional Winetricks Packages ---
  ADDITIONAL_WT=""
  dialog --yesno "Additional Winetricks\n\nDo you want to install additional winetricks packages (fetched from the official list)?" 12 60
  if [ $? -eq 0 ]; then
      WT_URL="https://raw.githubusercontent.com/Winetricks/winetricks/master/files/verbs/all.txt"
      WT_TEMP=$(mktemp)
      curl -sL "$WT_URL" -o "$WT_TEMP"
      if [ ! -s "$WT_TEMP" ]; then
          dialog --msgbox "Error: Failed to fetch winetricks list." 10 40
          ADDITIONAL_WT=""
      else
          WT_PARSED=$(mktemp)
          # Remove section headers and blank lines.
          grep -v '^=====' "$WT_TEMP" | grep -v '^[[:space:]]*$' > "$WT_PARSED"
          ADD_OPTIONS=()
          while IFS= read -r line; do
              # Use first word as the package name and the rest as description.
              pkg=$(echo "$line" | awk '{print $1}')
              desc=$(echo "$line" | cut -d' ' -f2-)
              ADD_OPTIONS+=("$pkg" "$desc" "off")
          done < "$WT_PARSED"
          ADD_SELECTION=$(dialog --stdout --checklist "Select additional winetricks packages:" 30 85 10 "${ADD_OPTIONS[@]}")
          ADDITIONAL_WT=$(echo $ADD_SELECTION | tr -d '"')
          rm -f "$WT_PARSED" "$WT_TEMP"
      fi
  fi
  
  # --- STEP 5: Compile the final winetricks package list ---
  FINAL_PACKAGES=""
  if [ -n "$COMMON_WT" ]; then
      FINAL_PACKAGES="$COMMON_WT"
  fi
  if [ -n "$ADDITIONAL_WT" ]; then
      FINAL_PACKAGES="$FINAL_PACKAGES $ADDITIONAL_WT"
  fi
  
  # If no packages were selected, let the user know and exit.
  if [ -z "$FINAL_PACKAGES" ]; then
      dialog --msgbox "No winetricks packages selected. Nothing to do." 10 40
      clear
      exit 0
  fi
  
  # --- STEP 6: Notify and Run the winetricks command in unattended mode ---
  # Inform the user to check the main display for any installation prompts.
  dialog --msgbox "Check the main display for any installation prompts." 8 40
  export DISPLAY=:0.0
  dialog --infobox "Running winetricks on:\n$selected_wine\n\nPackages: $FINAL_PACKAGES" 10 60
  batocera-wine windows tricks "$selected_wine" $FINAL_PACKAGES unattended
  
  dialog --msgbox "Winetricks processing complete." 8 40
  
  # --- STEP 7: Offer to process another wine bottle ---
  dialog --yesno "Do you want to process another bottle?" 8 40
  if [ $? -ne 0 ]; then
      clear
      exit 0
  fi
  clear
done

