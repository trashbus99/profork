#!/bin/bash

# Define the options
OPTIONS=(
  "1" "Wine & Proton (vanilla/regular)"
  "2" "Wine-TKG-Staging"
  "3" "Wine-GE Custom"
  "4" "GE-Proton"
  "5" "Prepare VC+/DX9/Steamy-AIO Wine Dependency Installer next for next windows app run"
  "6" "Easy Batocera Wine Tricks"
  "7" "Easy autorun.cmd creator"
  "8" "Convert .pc folder to .wine folder"
  "9" "Compress .wine folder to .wsquashfs or .tgz file"
  "10" "Decompress a .wsquashfs or .tgz file back to .wine"
)

# Use dialog to display the menu
CHOICE=$(dialog --clear --backtitle "Wine Installation" \
                --title "Select a Version or tool..." \
                --menu "Choose a Wine Tool to use or version to install:" \
               30 90 9 \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

# Clear the dialog artifacts
clear

# Run the appropriate script based on the user's choice
case $CHOICE in
    1)
        echo "You chose Wine Vanilla and Proton."
        curl -L https://github.com/trashbus99/profork/raw/master/wine-custom/vanilla.sh | bash
        ;;
    2)
        echo "You chose Wine-tkg staging."
        curl -L https://github.com/trashbus99/profork/raw/master/wine-custom/tkg.sh | bash
        ;;
    3)
        echo "You chose Wine-GE Custom."
        curl -L https://github.com/trashbus99/profork/raw/master/wine-custom/wine-ge.sh | bash
        ;;
    4)
        echo "You chose GE-Proton."
        curl -L https://github.com/trashbus99/profork/raw/master/wine-custom/ge-proton.sh | bash
        ;;
    5)
        echo "You chose Prepare installers next run."
        curl -L https://github.com/trashbus99/profork/raw/master/wine-custom/deps.sh | bash
        ;;
    6)
        echo "You chose Easy Batocera Wine Tricks."
        curl -L https://github.com/trashbus99/profork/raw/master/wine-custom/tricks.sh | bash
        ;;
    7)
        echo "You chose Easy autorun.cmd creator."
        curl -L https://github.com/trashbus99/profork/raw/master/wine-custom/ar.sh | bash
        ;;
    8)
        echo "You chose to convert a .pc folder to a .wine folder."
        curl -L https://github.com/trashbus99/profork/raw/master/wine-custom/wc.sh | bash
        ;;
    9)
        echo "You chose to compress a .wine folder to a .wsquashfs or .tgz file."
        curl -L https://github.com/trashbus99/profork/raw/master/wine-custom/squash.sh | bash
        ;;
    10)
        echo "You chose to decompress a .wsquashfs or .tgz file. to a.wine"
        curl -L https://github.com/trashbus99/profork/raw/master/wine-custom/unsquash.sh | bash
        ;;
    *)
        echo "Invalid choice or no choice made. Exiting."
        ;;
esac
