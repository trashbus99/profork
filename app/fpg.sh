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
    exit 0
fi
# This script uses DIALOG to display an alphabetically sorted checklist of Flatpak games.
# Each entry includes a description. When you select games and confirm, the script installs
# them system‑wide (using --system). Run the script as root or via sudo.
#
# Ensure you have DIALOG installed (e.g., on Debian/Ubuntu: sudo apt-get install dialog)

# Ensure the Flathub remote is added (system-wide)
echo "Ensuring Flathub remote is added..."
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# Declare an associative array mapping display names to their Flatpak App IDs.
declare -A games
games["0AD"]="app/com.play0ad.zeroad/x86_64/stable"
games["AssaultCube"]="app/net.cubers.assault.AssaultCube/x86_64/stablee"
games["AstroMenace"]="Astromenace"
games["BZFlag"]="BZFlag"
games["Chromium-BSU"]="net.sourceforge.chromium-bsu"
games["Commander-Genius"]="io.sourceforge.clonekeenplus"
games["Cosmic-Expansion"]="io.github.chimi70.cosmic-expansion"
games["Crossfire-(Angband)"]="Angband"
games["Cromagrally"]="io.jor.cromagrally"
games["Dune-Legacy"]="net.sourceforge.DuneLegacy"
games["FlightGear"]="FlightGear"
#games["FreeOrion"]="FreeOrion"
#games["Freeciv"]="app/org.freeciv.Freeciv/x86_64/stable"
#games["Freedoom"]="io.github.freedoom.FreeDM "
games["Frozen-Bubble"]="app/org.frozen_bubble.frozen-bubble/x86_64/stable"
games["Glest-(MegaGlest)"]="Glest"
games["Hedgewars"]="Hedgewars"
#games["Itch"]="io.itch.itch"
games["Kobo-Deluxe"]="net.olofson.KoboDeluxe"
games["Mindustry"]="Mindustry"
games["Minetest"]="Minetest"
games["Nexuiz"]="Nexuiz"
games["OpenArena"]="io.github.ec_.Quake3e.OpenArena "
games["OpenMW"]="OpenMW"
games["OpenRCT2"]="OpenRCT2"
games["OpenTTD"]="OpenTTD"
games["ROTA"]="app/net.hhoney.rota/x86_64/stable"
games["Sonic-Robo-Blast-2"]="org.srb2.SRB2"
games["Sonic-Robo-Blast-2-Kart"]="org.srb2.SRB2Kart"
games["Sonic3AIR"]="org.sonic3air.Sonic3AIR"
games["Shattered-Pixel-Dungeon"]="com.shatteredpixel.shatteredpixeldungeon"
games["Simutrans"]="Simutrans"
games["SpaceCadet-Pinball"]="com.github.k4zmu2a.spacecadetpinball"
games["Starfighter"]="io.github.pr_starfighter.starfighter"
games["Tremulous"]="Tremulous"
games["Unvanquished"]="Unvanquished"
#games["Warsow"]="Warsow"
games["Widelands"]="Widelands"
games["X2048"]="net.zdechov.app.x2048"
games["Xonotic"]="Xonotic"

# Declare an associative array for descriptions (keys match display names)
declare -A desc
desc["0AD"]="Real-time strategy set in ancient times."
desc["AssaultCube"]="Lightweight, fast-paced FPS."
desc["AstroMenace"]="Classic space combat and adventure."
desc["BZFlag"]="3D tank battle multiplayer game."
desc["Chromium-BSU"]="Fast paced, arcade style, top scrolling space shooter."
desc["Commander-Genius"]="Commander Keen port/downloader/manager"
desc["Cosmic-Expansion"]="Mod expansion for cosmic-themed gameplay."
desc["Crossfire-(Angband)"]="Turn-based dungeon crawler (Angband variant)."
desc["Cromagrally"]="Off-road rally racing simulation."
desc["Dune-Legacy"]="Remake of the classic Dune strategy game."
desc["FlightGear"]="Realistic flight simulator."
#desc["FreeOrion"]="Open-source space strategy game."
#desc["Freeciv"]="Turn-based civilization simulation game."
#desc["Freedoom"]="Asset-free FPS engine game."
desc["Frozen-Bubble"]="Puzzle game with penguins and bubbles."
desc["Glest-(MegaGlest)"]="Open-source real-time strategy game."
desc["Hedgewars"]="Turn-based artillery game with hedgehogs."
#desc["Itch"]="Platform for indie game distribution."
desc["Kobo-Deluxe"]="Enhanced version of the classic Kobo puzzle game."
desc["Mindustry"]="Factory-building tower defense game."
desc["Minetest"]="Open-source voxel game inspired by Minecraft."
desc["Nexuiz"]="Fast-paced arena shooter."
desc["OpenArena"]="Multiplayer arena shooter based on Quake III."
desc["OpenMW"]="Open-source engine for Morrowind."
desc["OpenRCT2"]="Reimplementation of RollerCoaster Tycoon 2."
desc["OpenTTD"]="Business simulation based on Transport Tycoon."
desc["ROTA"]="Character rotation puzzle game."
desc["Sonic-Robo-Blast-2"]="3D Sonic fan game with fast-paced action."
desc["Sonic-Robo-Blast-2-Kart"]="Kart racing featuring Sonic Robo Blast 2 characters."
desc["Sonic3AIR"]="3D Sonic fan game with high-flying action."
desc["Shattered-Pixel-Dungeon"]="Roguelike dungeon crawler with pixel art."
desc["Simutrans"]="Transport simulation and logistics game."
desc["SpaceCadet-Pinball"]="Classic pinball simulation game."
desc["Starfighter"]="Space combat and dogfighting simulator."
desc["Tremulous"]="FPS/RTS hybrid featuring aliens and humans."
desc["Unvanquished"]="Sci-fi FPS with real-time strategy elements."
#desc["Warsow"]="Fast-paced futuristic arena shooter."
desc["Widelands"]="Real-time strategy and resource management game."
desc["X2048"]="Puzzle game similar to 2048 with a twist."
desc["Xonotic"]="Open-source arena shooter with fast action."

# Build an array of DIALOG checklist parameters in alphabetical order.
dialog_items=()
for game in $(printf "%s\n" "${!games[@]}" | sort); do
  dialog_items+=( "$game" "${desc[$game]}" "off" )
done

# Create a temporary file for dialog output.
tempfile=$(mktemp 2>/dev/null) || tempfile=/tmp/dialog_output$$

# Display the checklist dialog.
dialog --clear --checklist "Select games to install" 40 120 20 \
  "${dialog_items[@]}" 2> "$tempfile"

# Capture the selected items.
selected=$(cat "$tempfile")
rm -f "$tempfile"
clear

# Exit if nothing was selected.
if [ -z "$selected" ]; then
  echo "No games selected. Exiting."
  exit 0
fi

# Convert the space-separated, quoted list into an array.
selected_games=()
for item in $selected; do
  item=$(echo "$item" | sed 's/^"//; s/"$//')
  selected_games+=( "$item" )
done

# Install each selected game using its Flatpak App ID.
for game in "${selected_games[@]}"; do
  app_id=${games["$game"]}
  if [ -n "$app_id" ]; then
    echo "Installing $game ($app_id)..."
    flatpak install --system -y flathub "$app_id"

    # Special handling for 0AD: create launcher
    if [[ "$game" == "0AD" ]]; then


      cat << 'EOF' > /userdata/roms/ports/0AD.sh
#!/bin/bash

APP_ID="com.play0ad.zeroad"
FLATPAK_HOME="/userdata/saves/flatpak/data"
VAR_DIR="$FLATPAK_HOME/.var/app/$APP_ID"
CONFIG_DIR="$VAR_DIR/config/0ad"
CACHE_DIR="$VAR_DIR/cache"
RUNTIME_DIR="/tmp/runtime-batocera"

# Create necessary dirs for 0 A.D.
mkdir -p "$CONFIG_DIR" "$CACHE_DIR" "$RUNTIME_DIR"
chown -R batocera:batocera "$VAR_DIR" "$RUNTIME_DIR"
chmod -R u+rwX "$VAR_DIR"
chmod 700 "$RUNTIME_DIR"

# PulseAudio permissions fix
if [ -d /var/run/pulse ]; then
  chown -R root:audio /var/run/pulse
  chmod -R g+rwX /var/run/pulse
fi

# Ensure ~/.local exists for batocera user
su - batocera -c '
mkdir -p ~/.local
chmod 755 ~/.local
'

# Launch 0 A.D.
su - batocera -c "
XDG_DATA_DIRS=$FLATPAK_HOME/.local/share:/usr/local/share:/usr/share \
XDG_CONFIG_HOME=$FLATPAK_HOME/.config \
XDG_CACHE_HOME=$FLATPAK_HOME/.cache \
XDG_RUNTIME_DIR=$RUNTIME_DIR \
DISPLAY=:0 \
flatpak run $APP_ID
"
EOF

      chmod +x /userdata/ports/0AD.sh
      echo "0 A.D. launcher created!"
    fi

  else
    echo "No App ID found for $game, skipping..."
  fi
done

echo "Installation complete."
echo "Refresh EmulationStation to see 0 A.D. under Ports (if selected)."
