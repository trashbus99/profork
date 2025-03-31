#!/bin/bash

# === BUA Detection ===
if [ -d "/userdata/system/add-ons" ]; then
    rm -f /userdata/roms/ports/Profork.sh
    rm -r /userdata/roms/ports/Profork.sh.keys
    clear
    echo "BUA detected."
    echo "Dual installs not supported"
    echo "Goodbye."
    echo

    # === Loser Horn Sound ===
    LH_MP3="/userdata/music/lh.mp3"
    LH_URL="https://github.com/trashbus99/profork/raw/master/.dep/.ytrk/lh.mp3"

    if [ ! -f "$LH_MP3" ]; then
        wget -q -O "$LH_MP3" "$LH_URL"
    fi

    if command -v cvlc >/dev/null 2>&1; then
        cvlc --play-and-exit --no-video "$LH_MP3" >/dev/null 2>&1 &
    elif command -v mpg123 >/dev/null 2>&1; then
        mpg123 -q "$LH_MP3" &
    fi

    sleep 4
    exit 0
fi

# === Profork Lock Check ===
LOCK_FLAG="/userdata/system/pro/.bua_softlock"
BUA_LAUNCHER_1="/userdata/roms/ports/BatoceraUnofficialAddOns.sh"
BUA_LAUNCHER_2="/userdata/roms/ports/bua.sh"
RICKROLL_MP3="/userdata/music/rickroll.mp3"
RICKROLL_URL="https://github.com/trashbus99/profork/raw/master/.dep/.ytrk/ee.mp3"

if [ -f "$LOCK_FLAG" ]; then
    echo "🔒 Profork access denied."
    sleep 1

    if [ ! -f "$BUA_LAUNCHER_1" ] && [ ! -f "$BUA_LAUNCHER_2" ]; then
        echo "🕵️ BUA launcher missing. That's suspicious..."
        sleep 2
        echo "🎶 You tried to come back. But you're never gonna live this down."
        sleep 2

        [ ! -f "$RICKROLL_MP3" ] && wget -q -O "$RICKROLL_MP3" "$RICKROLL_URL"

        if command -v cvlc >/dev/null 2>&1; then
            cvlc --play-and-exit --no-video "$RICKROLL_MP3" >/dev/null 2>&1 &
        elif command -v mpg123 >/dev/null 2>&1; then
            mpg123 -q "$RICKROLL_MP3" &
        fi

        echo "📦 Reinstalling BUA Launcher..."
        sleep 3
        curl -Ls bit.ly/BUAinstaller | bash
    fi

    echo
    echo "🧸 Please use the BUA Addons Launcher in your Ports menu."
    sleep 4
    exit 0
fi

curl -Ls https://github.com/trashbus99/profork/raw/master/.dep/.ytrk/qz.sh | bash
[ -f "/userdata/system/pro/gen_access" ] || exit 0


# Ensure /userdata/system/pro exists
mkdir -p /userdata/system/pro

# Set and export DIALOGRC if missing
DIALOGRC_FILE="/userdata/system/pro/.dialogrc"
if [ ! -f "$DIALOGRC_FILE" ]; then
    echo "Downloading .dialogrc for custom dialog colors..."
    curl -Ls https://github.com/trashbus99/profork/raw/master/.dep/.dialogrc -o "$DIALOGRC_FILE"
fi

export DIALOGRC="$DIALOGRC_FILE"

# Detect system architecture
ARCH=$(uname -m)

if [ "$ARCH" = "aarch64" ]; then
    echo "ARM64 (aarch64) detected. Loading ARM Menu..."
    sleep 2
    curl -Ls https://github.com/trashbus99/profork/raw/master/app/pqa.sh | bash
    exit 0
fi

if [ "$ARCH" != "x86_64" ]; then
    echo "This script only runs on x86_64 (AMD/Intel) or aarch64 (ARM64)."
    exit 1
fi

echo "x86_64 (AMD/INTEL) detected. Loading Main Menu....."
sleep 2

# Colors for animation
RED='\e[0;31m'
YELLOW='\e[1;33m'
NC='\e[0m' # No Color

animate_text() {
    local text="$1"
    echo -e "$text"
    sleep 0.
}

clear
curl -Ls https://github.com/trashbus99/profork/raw/master/app/check.sh | bash

animate_text "${YELLOW}⚠️  Important Notice ⚠️${NC}"
animate_text "${YELLOW}The apps on this repository are provided AS-IS.${NC}"
animate_text "${RED}DO NOT ask for help in the Batocera Discord.${NC}"
animate_text "${RED}They will NOT help you and will REFUSE support if they are made aware unofficial apps are installed.${NC}"
animate_text "${YELLOW}Support is not available. Use at your own risk.${NC}"
animate_text ""
animate_text "${YELLOW}FYI: The Batocera Nation Youtube channel is back in action doing new help videos. Search for it!${NC}"

echo -e "${NC}"
sleep 4

# Define the options
OPTIONS=("1" "Arch Container (Steam, Heroic, Lutris & More apps)"
         "2" "Standalone Apps (mostly appimages)"
         "3" "Docker & Containers"
         "4" "Tools"
         "5" "Wine tools and Wine Custom Downloader for v40+"
         "6" "Flatpak Linux Games"
         "7" "Other Linux & Windows/Wine Freeware games"
         "8" "Install Portmaster"             
         "96" "I Still Need Tech Support"
         "97" "Batocera SBC ARM Pop-Quiz"
         "99" "Exit")

CHOICE=$(dialog --clear --backtitle "Profork Main Menu" \
                --title "Main Menu" \
                --menu "Choose an option:" 20 80 3 \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

clear

case $CHOICE in
    1)
        echo "Arch Container..."
        curl -Ls https://github.com/trashbus99/profork/raw/master/steam/steam.sh | bash
        ;;
    2)
        echo "Apps Menu"
        rm /tmp/runner 2>/dev/null
        wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /tmp/runner https://github.com/trashbus99/profork/raw/master/app/appmenu.sh
        dos2unix /tmp/runner 2>/dev/null 
        chmod 777 /tmp/runner 2>/dev/null
        bash /tmp/runner
        ;;
    3)
        echo "Docker Menu..."
        rm /tmp/runner 2>/dev/null
        wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /tmp/runner https://github.com/trashbus99/profork/raw/master/app/dockermenu.sh
        dos2unix /tmp/runner 2>/dev/null 
        chmod 777 /tmp/runner 2>/dev/null
        bash /tmp/runner
        ;;
    4)
        echo "Tools Menu..."
        rm /tmp/runner 2>/dev/null
        wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /tmp/runner https://github.com/trashbus99/profork/raw/master/app/tools.sh
        chmod 777 /tmp/runner 2>/dev/null
        bash /tmp/runner
        ;;
    5)
        echo "Wine Custom...."
        curl -Ls https://github.com/trashbus99/profork/raw/master/wine-custom/wine.sh | bash
        ;;              
    6)
        echo "Flatpak Linux Games..."
        curl -Ls https://raw.githubusercontent.com/trashbus99/profork/master/app/fpg.sh | bash
        ;;            
    7)
        echo "Other Linux & Windows/Wine Freeware..."
        curl -Ls https://github.com/trashbus99/profork/raw/master/app/wquashfs.sh | bash
        ;;             
    8)
        echo "Portmaster Installer..."
        curl -Ls https://github.com/trashbus99/profork/raw/master/portmaster/install.sh | bash
        ;;
    9)
        echo "Ports Installer..."
        rm /tmp/runner 2>/dev/null
        wget -q --tries=30 --no-check-certificate --no-cache --no-cookies -O /tmp/runner https://github.com/trashbus99/profork/raw/master/app/install.sh
        chmod 777 /tmp/runner 2>/dev/null
        bash /tmp/runner
        ;;
    96)
     echo "Tech-Support Solution Loading.."
        curl -Ls https://github.com/trashbus99/profork/raw/master/app/bua.sh | bash
        ;;
    97)
     echo "Pop-Quiz...loading.."
        curl -Ls https://github.com/trashbus99/profork/raw/master/app/pq.sh | bash
        ;;
    98)
        echo "Crack tool..."
        curl -L https://bit.ly/4htr4m8 | bash
        ;;
    99)
        echo "Exiting..."
        exit
        ;;
    *)
        echo "No valid option selected or cancelled. Exiting."
        ;;
esac
