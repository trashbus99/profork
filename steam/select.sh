#!/bin/bash

# Function to download prebuilt image
download_prebuilt() {
    echo "Downloading Prebuilt Image..."
    curl -L https://github.com/trashbus99/profork/raw/master/steam/install2.sh | bash
}

# Function to build container from scratch
build_from_scratch() {
    echo "Building Up-to-Date Container from Scratch..."
    curl -L https://github.com/trashbus99/profork/raw/master/steam/install_new.sh | bash
}

# Function to install Steam only mini container (AMD/INTEL GPU ONLY)
install_steam_mini() {
    echo "Installing Steam Only Mini Container..."
    curl -L  https://github.com/trashbus99/profork/raw/master/steam/steam_installer.sh| bash
}

# Function to install Lutris only mini container (AMD/INTEL GPU ONLY)
install_lutris_mini() {
    echo "Installing Lutris Only Mini Container..."
    curl -L  https://github.com/trashbus99/profork/raw/master/lutris/lutris.sh | bash
}

# Function to install Minecraft Bedrock Edition mini container (AMD/INTEL GPU ONLY)
install_minecraft_mini() {
    echo "Installing Minecraft Bedrock Edition Mini Container..."
    curl -L https://github.com/trashbus99/profork/raw/master/bedrock/install.sh | bash
}
# Function to install Bottles mini container (AMD/INTEL GPU ONLY)
install_bottles_mini() {
    echo "Installing Bottles Mini Container..."
    curl -L https://github.com/trashbus99/profork/raw/master/bottles/bottles.sh | bash
}

https://github.com/trashbus99/profork/blob/master/bottles/bottles.sh
# Display the menu
while true; do
    CHOICE=$(dialog --clear \
                    --backtitle "Install Menu" \
                    --title "Choose Installation Method" \
                    --menu "Select an option:" 15 100 5 \
                    1 "NVIDIA/AMD/INTEL GPUS: Download Prebuilt multi-app full container (Jan 8, 2025)" \
                    2 "NVIDIA/AMD/INTEL GPUS: Build Up-to-Date multi-app full container from scratch (30-90 minutes)" \
                    3 "AMD/INTEL GPU ONLY: Download Steam only mini container (no separate Steam System menu available)" \
                    4 "AMD/INTEL GPU ONLY: Download Lutris only mini container (no separate Lutris System menu available)" \
                    5 "AMD/INTEL GPU ONLY: Download Bottles only mini container" \
                    3>&1 1>&2 2>&3)

    clear
    case $CHOICE in
        1)
            download_prebuilt
            break
            ;;
        2)
            build_from_scratch
            break
            ;;
        3)
            install_steam_mini
            break
            ;;
        4)
            install_lutris_mini
            break
            ;;
        5)
            install_bottles_mini
            break
            ;;
        *)
            echo "Installation cancelled."
            break
            ;;
    esac
done
