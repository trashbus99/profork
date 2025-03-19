#!/bin/bash
# Get the machine hardware name
architecture=$(uname -m)

# Check if the architecture is x86_64 (AMD/Intel)
if [ "$architecture" != "x86_64" ]; then
    echo "This script only runs on AMD or Intel (x86_64) CPUs, not on $architecture."
    exit 1
fi

clear

# Function to display animated title with colors
animate_title() {
    local text="PROFORK Standalone App menu (h/t UUREEL)"
    local delay=0.03
    local length=${#text}

    echo -ne "\e[1;36m" # Set color to cyan

    for (( i=0; i<length; i++ )); do
        echo -n "${text:i:1}"
        sleep $delay
    done

    echo -e "\e[0m" # Reset color
}

# Function to display animated border
animate_border() {
    local char="#"
    local width=50

    for (( i=0; i<width; i++ )); do
        echo -n "$char"
        sleep 0.02
    done
    echo
}

# Function to display controls
display_controls() {
    echo -e "\e[1;32m" # Set color to green
    echo "K/B Controls + Gamepad Controls when launched from ports:"
    echo "  Navigate with up-down-left-right"
    echo "  Select app with A/B/SPACE and execute with Start/X/Y/ENTER"
    echo -e "\e[0m" # Reset color
    sleep 4
}

# Function to display loading animation
loading_animation() {
    local delay=0.1
    local spinstr='|/-\'
    echo -n "Loading "
    while :; do
        for (( i=0; i<${#spinstr}; i++ )); do
            echo -ne "${spinstr:i:1}"
            echo -ne "\010"
            sleep $delay
        done
    done &
    spinner_pid=$!
    sleep 3
    kill $spinner_pid
    echo "Done!"
}

# Main script execution
clear
animate_border
animate_title
animate_border
display_controls

# Define an associative array for app names and their install commands
declare -A apps
apps=(
    ["2SHIP2HARKINIAN"]="curl -Ls https://github.com/trashbus99/profork/raw/master/soh/2s2h.sh | bash"
    ["7ZIP"]="curl -Ls https://github.com/trashbus99/profork/raw/master/7zip/7zip.sh | bash"
    ["ALTUS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/altus/altus.sh | bash"
    ["AMAZON-LUNA"]="curl -Ls https://github.com/trashbus99/profork/raw/master/amazonluna/amazonluna.sh"
    ["ANTIMICROX"]="curl -Ls https://github.com/trashbus99/profork/raw/master/antimicrox/antimicrox.sh | bash"
    ["APPLEWIN/WINE"]="curl -Ls https://github.com/trashbus99/profork/raw/master/applewin/applewin.sh | bash"
    ["ARCADE-MANAGER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/arcade-manager/arcade.sh | bash"
    ["ATOM"]="curl -Ls https://github.com/trashbus99/profork/raw/master/atom/atom.sh | bash"
    ["BALENA-ETCHER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/balena/balena.sh | bash"
    ["BLENDER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/blender/blender.sh | bash"
    ["BOTTLES/AMD-INTEL-GPUS-ONLY"]="curl -Ls https://github.com/trashbus99/profork/raw/master/bottles/bottles.sh | bash"
    ["BRAVE"]="curl -Ls https://github.com/trashbus99/profork/raw/master/brave/brave.sh | bash"
    ["CHIAKI"]="curl -Ls https://github.com/trashbus99/profork/raw/master/chiaki/chiaki.sh | bash"
    ["CHROME"]="curl -Ls https://github.com/trashbus99/profork/raw/master/chrome/chrome.sh | bash"
    ["CLONE-HERO"]="curl -LS https://github.com/trashbus99/profork/raw/master/clonehero/clonehero.sh | bash"
    ["CPU-X"]="curl -Ls https://github.com/trashbus99/profork/raw/master/cpux/cpux.sh | bash"
    ["DISCORD"]="curl -Ls https://github.com/trashbus99/profork/raw/master/discord/discord.sh | bash"
    ["EDGE"]="curl -Ls https://github.com/trashbus99/profork/raw/master/edge/edge.sh | bash"
 #   ["ENDLESS-SKY"]="curl -Ls https://github.com/trashbus99/profork/raw/master/endlesssky/endlesssky.sh | bash"
    ["FERDIUM"]="curl -Ls https://github.com/trashbus99/profork/raw/master/ferdium/ferdium.sh | bash"
    ["FILEZILLA"]="curl -Ls https://github.com/trashbus99/profork/raw/master/filezilla/filezilla.sh | bash"
    ["FIREFOX"]="curl -Ls https://github.com/trashbus99/profork/raw/master/firefox/firefox.sh | bash"
    ["FOOBAR2000"]="curl -Ls https://github.com/trashbus99/profork/raw/master/foobar/foobar.sh | bash"
    ["GEFORCENOW"]="curl -Ls https://github.com/trashbus99/profork/raw/master/geforcenow/geforcenow.sh | bash"
    ["GREENLIGHT"]="curl -Ls https://github.com/trashbus99/profork/raw/master/greenlight/greenlight.sh | bash"
    ["HARD-INFO"]="curl -Ls https://github.com/trashbus99/profork/raw/master/hardinfo/hardinfo.sh | bash"
#    ["HYDORAH"]="curl -Ls https://github.com/trashbus99/profork/raw/master/hydorah/hydorah.sh | bash" 
    ["HYPER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/hyper/hyper.sh | bash"
    ["JAVA-RUNTIME"]="curl -Ls https://github.com/trashbus99/profork/raw/master/java/java.sh | bash"
    ["KDENLIVE"]="curl -Ls https://github.com/trashbus99/profork/raw/master/kdenlive/kdenlive.sh |bash"
    ["KITTY"]="curl -Ls https://github.com/trashbus99/profork/raw/master/kitty/kitty.sh | bash"
    ["KSNIP"]="curl -Ls https://github.com/trashbus99/profork/raw/master/ksnip/ksnip.sh | bash"
    ["KRITA"]="curl -Ls https://github.com/trashbus99/profork/raw/master/krita/krita.sh | bash"
    ["LIBREWOLF"]="curl -Ls https://github.com/trashbus99/profork/raw/master/librewolf/install_x86_64.sh | bash"
    ["LUANTI"]="curl -Ls https://github.com/trashbus99/profork/raw/master/luanti/extra/lua.sh | bash"
    ["LUDUSAVI"]="curl -Ls https://github.com/trashbus99/profork/raw/master/ludusavi/ludusavi.sh | bash"
    ["LUTRIS/AMD-INTEL-GPUS-ONLY"]="curl -Ls https://github.com/trashbus99/profork/raw/master/lutris/lutris.sh | bash"
    ["MEDIAELCH"]="curl -Ls https://github.com/trashbus99/profork/raw/master/mediaelch/mediaelch.sh | bash"
    ["MINECRAFT-BEDROCK-EDITION"]="curl -Ls https://raw.githubusercontent.com/trashbus99/profork/refs/heads/master/bedrock/install.sh | bash"
    ["MINECRAFT-JAVA-EDITION"]="curl -Ls https://github.com/trashbus99/profork/raw/master/minecraft/minecraft.sh | bash"
    ["MOONLIGHT"]="curl -Ls https://github.com/trashbus99/profork/raw/master/moonlight/moonlight.sh | bash"
    ["MPV"]="curl -Ls https://github.com/trashbus99/profork/raw/master/mpv/mpv.sh | bash"
    ["MULTIMC-LAUNCHER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/multimc/multimc.sh | bash"
    ["MUSEEKS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/museeks/museeks.sh | bash"
    ["NVTOP"]="curl -Ls https://github.com/trashbus99/profork/raw/master/nvtop/nvtop.sh| bash"
    ["ODIO"]="curl -Ls https://github.com/trashbus99/profork/raw/master/odio/odio.sh | bash"
    ["OLIVE"]="curl -Ls https://github.com/trashbus99/profork/raw/master/olive/olive.sh | bash"
    ["OPENGOAL"]="curl -Ls https://github.com/trashbus99/profork/raw/master/opengoal/og.sh | bash"
 #   ["OPEN-RA-TIBERIAN-DAWN"]="curl -Ls https://github.com/trashbus99/profork/raw/master/openra/td.sh | bash"
 #   ["OPEN-RA-RED-ALERT"]="curl -Ls https://github.com/trashbus99/profork/raw/master/openra/ra.sh | bash"
 #   ["OPEN-RA-DUNE-2000"]="curl -Ls https://github.com/trashbus99/profork/raw/master/openra/d2k.sh | bash"
    ["OPERA"]="curl -Ls https://github.com/trashbus99/profork/raw/master/opera/opera.sh | bash"
    ["PARSEC/CONTAINER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/parsec/parsec.sh | bash"
    ["PEAZIP"]="curl -Ls https://github.com/trashbus99/profork/raw/master/peazip/peazip.sh | bash"
    ["PLEXAMP"]="curl -Ls https://github.com/trashbus99/profork/raw/master/plexamp/installer.sh | bash"
    ["PRISM-LAUNCHER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/prismlauncher/prism.sh | bash"
    ["PROTONUP-QT"]="curl -Ls https://github.com/trashbus99/profork/raw/master/protonup-qt/protonup-qt.sh | bash"
    ["PS2MINUS"]="curl -Ls https://github.com/uureel/batocera.pro/raw/main/ps2minus/installer.sh | bash"
    ["PS2PLUS"]="curl -Ls https://github.com/uureel/batocera.pro/raw/main/ps2plus/installer.sh | bash"
    ["PS3PLUS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/ps3plus/installer.sh | bash"
    ["PS4"]="curl -Ls https://github.com/trashbus99/profork/raw/master/shadps4/shadps4.sh | bash"
    ["QBITTORRENT"]="curl -Ls https://github.com/trashbus99/profork/raw/master/qbittorrent/qbittorrent.sh | bash"
    ["SAYONARA"]="curl -Ls https://github.com/trashbus99/profork/raw/master/sayonara/sayonara.sh | bash"
    ["SECRET-EMULATOR"]="curl -Ls https://github.com/trashbus99/profork/aw/master/scripts/secret.sh | bash"
    ["SHIP-OF-HARKINIAN"]="curl -Ls https://github.com/trashbus99/profork/raw/master/soh/soh2.sh | bash"
    ["SHEEPSHAVER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/sheepshaver/install.sh | bash"
    ["SMPLAYER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/smplayer/smplayer.sh | bash"
    ["STARSHIP"]="curl -Ls https://github.com/trashbus99/profork/raw/master/soh/starship.sh | bash"
    ["STEAM/AMD-INTEL-GPUS-ONLY"]="curl -Ls https://raw.githubusercontent.com/trashbus99/profork/refs/heads/master/steam/steam_installer.sh"
    ["STRAWBERRY-MUSIC-PLAYER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/strawberry/strawberry.sh | bash"
    ["SUBLIME-TEXT"]="curl -Ls https://github.com/trashbus99/profork/raw/master/sublime/sublime.sh | bash"
    ["SUNSHINE"]="curl -Ls https://github.com/trashbus99/profork/raw/master/sunshine/installer.sh | bash"
    ["TABBY"]="curl -Ls https://github.com/trashbus99/profork/raw/master/tabby/tabby.sh | bash"
    ["TELEGRAM"]="curl -Ls https://github.com/trashbus99/profork/raw/master/telegram/telegram.sh | bash"
    ["TOTAL-COMMANDER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/totalcmd/totalcmd.sh | bash"
    ["UNLEASED-RECOMP"]="curl -Ls https://github.com/trashbus99/profork/raw/master/unleased-recomp/unleashed.sh | bash" 
    ["VIBER"]="curl -Ls  https://github.com/trashbus99/profork/raw/master/viber/viber.sh | bash"
    ["VIVALDI"]="curl -Ls https://github.com/trashbus99/profork/raw/master/vivaldi/vivaldi.sh | bash"
    ["VIRTUALBOX"]="curl -Ls https://github.com/trashbus99/profork/raw/master/virtualbox/vbox.sh | bash"
    ["VLC"]="curl -Ls https://github.com/trashbus99/profork/raw/master/vlc/vlc.sh | bash"
    ["WHATSAPP"]="curl -Ls https://github.com/trashbus99/profork/raw/master/whatsapp/whatsapp.sh | bash"
    ["WIIUPLUS"]="curl -Ls https://github.com/uureel/batocera.pro/raw/main/wiiuplus/installer.sh | bash"
    ["XCLOUD"]="curl -Ls https://github.com/trashbus99/profork/raw/master/xcloud/xcloud.sh | bash"
    ["WPS-OFFICE"]="curl -Ls https://github.com/trashbus99/profork/raw/master/wps-office/wps.sh | bash"
    ["YARG"]="curl -Ls https://github.com/trashbus99/profork/raw/master/yarg/yarg.sh | bash"
    ["YOUTUBE-MUSIC"]="curl -Ls https://github.com/trashbus99/profork/raw/master/youtube-music/ytm.sh | bash"
    ["YOUTUBE-TV"]="curl -Ls https://github.com/trashbus99/profork/raw/master/youtubetv/yttv.sh | bash"
)

# Define an associative array for app descriptions (generated from your table)
declare -A app_desc
app_desc=(
    ["2SHIP2HARKINIAN"]="Open Source Port of Majora's Mask Engine"
    ["7ZIP"]="File archiver with a high compression ratio"
    ["ALTUS"]="Desktop client for Google Meet and messaging services"
    ["AMAZON-LUNA"]="Amazon's cloud gaming service"
    ["ANTIMICROX"]="Gamepad mapping and customization tool"
    ["APPLEWIN/WINE"]="Apple II emulator"
    ["ARCADE-MANAGER"]="ROM management Tool"
    ["ATOM"]="Hackable text editor for developers"
    ["BALENA-ETCHER"]="Flash OS images to USB drives and SD cards"
    ["BLENDER"]="Open-source 3D modeling and animation tool"
    ["BOTTLES/AMD-INTEL-GPUS-ONLY"]="Manage and run Windows apps using Wine/proton"
    ["BRAVE"]="Privacy-focused web browser"
    ["CHIAKI"]="Open-source PS4 Remote Play client"
    ["CHROME"]="Popular web browser by Google"
    ["CLONE-HERO"]="Guitar/Music Game"
    ["CPU-X"]="System profiling and monitoring application"
    ["DISCORD"]="Voice, video, and text chat app"
    ["EDGE"]="Web browser by Microsoft"
    ["ENDLESS-SKY"]="Free open-world space exploration game"
    ["FERDIUM"]="Messaging app with support for multiple platforms"
    ["FILEZILLA"]="FTP, FTPS, and SFTP client"
    ["FIREFOX"]="Open-source web browser"
    ["FOOBAR2000"]="Lightweight and customizable audio player"
    ["GEFORCENOW"]="Nvidia's cloud gaming service"
    ["GREENLIGHT"]="Xbox and Xcloud Remote Play Streamer"
    ["HARD-INFO"]="System information and benchmark tool"
#   ["HYDORAH"]="2010 Windows Shmup game"
    ["HYPER"]="Modern, extensible terminal emulator"
    ["JAVA-RUNTIME"]="Java runtime environment"
    ["KDENLIVE"]="Open-source video editing software"
    ["KITTY"]="Fast and feature-rich terminal emulator"
    ["KSNIP"]="Screenshot tool with annotation features"
    ["KRITA"]="Professional digital painting and illustration software"
    ["LIBREWOLF"]="Freedom and Privacy Based Web Browser"
    ["LUANTI"]="Minetest: Open-source voxel game engine"
    ["LUDUSAVI"]="Save game manager and backup tool"
    ["LUTRIS/AMD-INTEL-GPUS-ONLY"]="Open-source gaming platform"
    ["MEDIAELCH"]="Media manager for movies and TV shows"
    ["MINECRAFT-BEDROCK-EDITION"]="Cross-platform version of Minecraft"
    ["MINECRAFT-JAVA-EDITION"]="Java-based version of Minecraft"
    ["MOONLIGHT"]="Open-source game streaming client for Sunshine/Geforce streaming"
    ["MPV"]="Lightweight media player"
    ["MULTIMC-LAUNCHER"]="Custom launcher for Minecraft mod versions"
    ["MUSEEKS"]="Lightweight and cross-platform music player"
    ["NVTOP"]="Real-time GPU usage monitoring tool"
    ["ODIO"]="Free streamimg music app"
    ["OLIVE"]="Open-source video editing tool"
    ["OPENGOAL"]="JakNDaxter/2/3 Opensource Engine"
    ["OPEN-RA-TIBERIAN-DAWN"]="Freeware version of Original CNC"
    ["OPEN-RA-RED-ALERT"]="Freeware version of Original CNC Red Alert"
    ["OPEN-RA-DUNE-2000"]="Freeware version of Dune 2000"
    ["OPERA"]="Web browser with integrated VPN and ad blocker"
    ["PARSEC/CONTAINER"]="Parsec Streaming Client"
    ["PEAZIP"]="File archiver and compression utility"
    ["PLEXAMP"]="Music player for Plex users"
    ["PRISM-LAUNCHER"]="Custom Minecraft launcher for mod versions"
    ["PROTONUP-QT"]="Manage Proton-GE builds for Linux gaming"
    ["PS2MINUS"]="Older (wx) version v1.6 of the PCSX2 emulator for older machines"
    ["PS2PLUS"]="Latest version of the PCSX2 emulator"
    ["PS3PLUS"]="Latest RPCS3 PlayStation 3 emulator"
    ["PS4"]="ShadPS4 Emulator/Batocera v40+ only"
    ["QBITTORRENT"]="Torrent Client"
    ["SAYONARA"]="Lightweight music player"
    ["SECRET-EMULATOR"]="Something about Mario"
    ["SHIP-OF-HARKINIAN"]="Open-source port of Ocarina of Time Engine"
    ["SHEEPSHAVER"]="PowerPC Mac emulator"
    ["SMPLAYER"]="Media player with built-in codecs"
    ["STARSHIP"]="Open-Source port of Starfox 64 Engine" 
    ["STEAM/AMD-INTEL-GPUS-ONLY"]="Popular gaming platform"
    ["STRAWBERRY-MUSIC-PLAYER"]="Music player with support for large libraries"
    ["SUBLIME-TEXT"]="Text editor for code, markup, and prose"
    ["SUNSHINE"]="Open-source game streaming software"
    ["TABBY"]="Modern, highly configurable terminal emulator"
    ["TELEGRAM"]="Messaging app"
    ["TOTAL-COMMANDER"]="File manager with advanced features"
    ["UNLEASED-RECOMP"]="Sonic Unleased Engine for PC"
    ["VIBER"]="Messaging and calling app"
    ["VIRTUALBOX"]="Oracle--Virtual machine App"
    ["VIVALDI"]="Customizable web browser"
    ["VLC"]="Open-source media player"
    ["WHATSAPP"]="Messaging app"
    ["WIIUPLUS"]="Newest CEMU build of Wii U emulator"
    ["XCLOUD"]="Electron based Xcloud client (Gamepad Navigatable)"
    ["WPS-OFFICE"]="Office suite"
    ["YARG"]="Yet Another Rhythm Game"
    ["YOUTUBE-MUSIC"]="Streaming app for YouTube Music"
    ["YOUTUBE-TV"]="Streaming app for Youtube with TV UI"
)

# Prepare array for dialog command, sorted by app name
app_list=()
for app in $(printf "%s\n" "${!apps[@]}" | sort); do
    # Use the modified app names (without spaces) to look up the description
    app_key="${app// /}"
    app_key="${app_key//[^[:alnum:]\/-]/_}" # Replace non-alphanumeric characters (except / and -) with _
    app_list+=("$app" "${app_desc[$app_key]}" OFF)
done

# Adjust dialog command for wider output
cmd=(dialog --separate-output --checklist "Select applications to install or update:" 22 90 25) # Adjust width and height here
choices=$("${cmd[@]}" "${app_list[@]}" 2>&1 >/dev/tty)

# Check if Cancel was pressed
if [ $? -eq 1 ]; then
    echo "Installation cancelled."
    exit
fi

# Install selected apps
for choice in $choices; do
    applink="$(echo "${apps[$choice]}" | awk '{print $3}')"
    rm /tmp/.app 2>/dev/null
    wget --tries=10 --no-check-certificate --no-cache --no-cookies -q -O "/tmp/.app" "$applink"
    if [[ -s "/tmp/.app" ]]; then
        dos2unix /tmp/.app 2>/dev/null
        chmod 777 /tmp/.app 2>/dev/null
        clear
        loading_animation

        # Capture the exit code of the installer
        if sed 's,:1234,,g' /tmp/.app | bash; then
            echo -e "\n\n$choice installed successfully.\n\n"
        else
            echo -e "\n\nError: Installation of $choice failed.\n\n"
            # Optionally, display the error output of the installer for debugging
        fi
    else
        echo "Error: Couldn't download installer for ${apps[$choice]}"
    fi
done

# Reload ES after installations
echo "Update game list to see any apps installed"
sleep 5

echo "Exiting."
