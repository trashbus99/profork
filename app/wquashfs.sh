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
clear 

# === Animated Title ===
animate_title() {
    local text="Linux & Windows/Wine Freeware Games"
    local delay=0.03
    local length=${#text}
    echo -ne "\e[1;36m"
    for (( i=0; i<length; i++ )); do
        echo -n "${text:i:1}"
        sleep $delay
    done
    echo -e "\e[0m"
}

animate_border() {
    local char="#"
    local width=50
    for (( i=0; i<width; i++ )); do
        echo -n "$char"
        sleep 0.02
    done
    echo
}

display_controls() {
    echo -e "\e[1;32m"
    echo "K/B Controls + Gamepad Controls when launched from ports:"
    echo "  Navigate with up-down-left-right"
    echo "  Select app with A/B/SPACE and execute with Start/X/Y/ENTER"
    echo -e "\e[0m"
    sleep 4
}

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
    done & spinner_pid=$!
    sleep 3
    kill $spinner_pid
    echo "Done!"
}

# === App Commands ===
declare -A apps
apps=(
    # Windows / Wine games
    ["Alleycat-Remeow-(Remake)/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/ac.sh | bash"
    ["Celeste-Classic/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/celeste.sh | bash"
    ["Celeste-64/LINUX"]="curl -Ls https://github.com/trashbus99/profork/raw/master/celeste64/c64.sh | bash"
    ["Apotris/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/apotris.sh | bash"
    ["Maldita-Castilla/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/maldita_castilla.sh | bash"
    ["Spelunky-Classic/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/spelunky.sh | bash"
    ["Donkey-Kong-Advanced/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/dka.sh | bash"
    ["Portaboy/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/portaboy.sh | bash"
    ["Teather-N-Feather/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/tnf.sh | bash"
    ["The-Ur-Quan-Masters/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/uqm.sh | bash"
    ["MEGAMAN-X8-16-BIT-DEMAKE/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/megamanx8.sh | bash"
    ["SHEEPY-A-SHORT-ADVENTURE/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/sheepy.sh | bash"
    ["SPACE-QUEST-3D/SQ3-REMAKE/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/sq3d.sh | bash"
    ["STARFIGHTER-MOVIE-ARCADE-GAME/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/starfighter.sh | bash"
    ["STRATOSPEAR-JAM/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/sj.sh | bash"
    ["AM2R/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/a2r.sh | bash"
    ["Z2-ADV-OF-LNK-Remake/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/z2r.sh | bash"
    ["TLOZ-DUNGEONS-OF-INFINITY/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/doi.sh | bash"
    ["HYDORA/WINDOWS-IN-CONTAINER"]="curl -Ls https://github.com/trashbus99/profork/raw/master/hydorah/hydorah.sh | bash"
    ["CRASH-BANDICOOT-BACK-IN-TIME/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/cbit.sh | bash"
    ["MODERN-MODERN-CHEF/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/mmc.sh | bash"
    ["SONIC-TRIPLE-TROUBLE/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/stt.sh | bash"
    ["TMNT-RESCUE-PALOOZA/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/tmntrp | bash"
    ["MEGA-MAN-AGAIN/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/mma.sh | bash"
    ["STREET-FIGHTER-X-MEGA-MAN/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/sfxmm.sh | bash"
    ["SONIC-AND-THE-FALLEN-STAR/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/safs.sh | bash"
    ["TROGDOR-REBURNIATED/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/tr.sh | bash"
    ["PullyWogTog/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/releases/download/r1/pullyWogPog.wtgz | bash"
    ["SUPERCRATEBOX/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/releases/download/r1/SuperCratebox.wtgz | bash"
    ["MEGAMAN-ROCK-N-ROLL/LINUX"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/mmrnr.sh | bash"
    ["GLOBEBA/WINDOWS"]="curl -Ls https://github.com/trashbus99/profork/raw/master/windows/glba.sh | bash"
    ["FLARE-RPG"]="curl -Ls https://github.com/trashbus99/profork/raw/master/openra/flare.sh | bash"
    
    # Linux pacman ports
    ["OPENRA-CNC-TIBERIAN-DAWN/LINUX"]="pacman -S --noconfirm batocera/ports-openra-td"
    ["OPENRA-CNC-RED-ALERT/LINUX"]="pacman -S --noconfirm batocera/ports-openra-ra"
    ["OPENRA-DUNE-2000/LINUX"]="pacman -S --noconfirm batocera/ports-openra-d2k"
    ["ENDLESS-SKY/LINUX"]="pacman -S --noconfirm batocera/ports-endless-sky"
    ["ROCKBOT/LINUX"]="pacman -S --noconfirm batocera/ports-rockbot"
    ["ROCKBOT2/LINUX"]="pacman -S --noconfirm batocera/ports-rockbot2"
    ["ABUSE/LINUX"]="pacman -S --noconfirm batocera/ports-abuse"
    ["C-DOGS/LINUX"]="pacman -S --noconfirm batocera/ports-cdogs"
    ["HYDRA-CASTLE-LABYRINTH/LINUX"]="pacman -S --noconfirm batocera/ports-hydra-castle-labyrinth"
    ["QUAKE-SHAREWARE/LINUX"]="pacman -S --noconfirm batocera/ports-quake-shareware"
    ["SUPER-BROS-WAR/LINUX"]="pacman -S --noconfirm batocera/ports-super-bros-war"
    ["SUPERTUXKART/LINUX"]="pacman -S --noconfirm batocera/ports-supertuxkart"
    ["TYRIAN/LINUX"]="pacman -S --noconfirm batocera/ports-tyrian"
    ["UNVANQUISHED/LINUX"]="pacman -S --noconfirm batocera/ports-unvanquished"
    ["VELOREN/LINUX"]="pacman -S --noconfirm batocera/ports-veloren"
    ["XRICK/LINUX"]="pacman -S --noconfirm batocera/ports-xrick"
    ["ZERO-K/LINUX"]="pacman -S --noconfirm batocera/ports-zero-k"
    ["RI-LI/WINDOWS"]="pacman -S --noconfirm batocera/wine-rili"
    ["XMOTO/WINDOWS"]="pacman -S --noconfirm batocera/wine-xmoto"
    ["OPERATION-KYBER-CRYSTAL/LINUX"]="pacman -S --noconfirm batocera/ports-tfe-Operation-Kyber-Crystal"
)

# === (continued below because of length) ===
# === Game Descriptions ===
declare -A descriptions
descriptions=(
    ["Alleycat-Remeow-(Remake)/WINDOWS"]="A modern remake of the 1983 classic Alley Cat, featuring updated graphics and smoother controls."
    ["Celeste-Classic/WINDOWS"]="The original PICO-8 version of Celeste, a tight and challenging platformer."
    ["Celeste-64/LINUX"]="A fan-made 3D platformer tribute to Celeste and Super Mario 64."
    ["Apotris/WINDOWS"]="A fast-paced, minimalist Tetris-like block game."
    ["Maldita-Castilla/WINDOWS"]="An arcade action game inspired by Ghosts 'n Goblins, set in medieval Spain."
    ["Spelunky-Classic/WINDOWS"]="The original free version of the hit roguelike platformer Spelunky."
    ["Donkey-Kong-Advanced/WINDOWS"]="A hard indie version of Donkey Kong with extra challenging levels."
    ["Portaboy/WINDOWS"]="A collection of fast-paced WarioWare-style microgames."
    ["Teather-N-Feather/WINDOWS"]="A relaxing 3D puzzle-platformer where you guide parrots across islands."
    ["The-Ur-Quan-Masters/WINDOWS"]="A remaster of the classic Star Control II space adventure game."
    ["MEGAMAN-X8-16-BIT-DEMAKE/WINDOWS"]="A 16-bit demake of Mega Man X8, retrofitted into classic SNES style."
    ["SHEEPY-A-SHORT-ADVENTURE/WINDOWS"]="A cute and short platformer about a little sheep's journey."
    ["SPACE-QUEST-3D/SQ3-REMAKE/WINDOWS"]="A fan remake of Space Quest III in 3D."
    ["STARFIGHTER-MOVIE-ARCADE-GAME/WINDOWS"]="A recreation of the arcade game seen in the 1984 movie The Last Starfighter."
    ["STRATOSPEAR-JAM/WINDOWS"]="VT must fight through an alien island full of hostile creatures to reunite with her ship."
    ["OPENRA-CNC-TIBERIAN-DAWN/LINUX"]="Open-source remake of Command & Conquer: Tiberian Dawn."
    ["OPENRA-CNC-RED-ALERT/LINUX"]="Open-source remake of Command & Conquer: Red Alert."
    ["OPENRA-DUNE-2000/LINUX"]="Open-source remake of Dune 2000."
    ["ENDLESS-SKY/LINUX"]="A free and open-source space trading and combat game."
    ["AM2R/WINDOWS"]="Another Metroid 2 Remake, a fan-made reimagining of Metroid II."
    ["Z2-ADV-OF-LNK-Remake/WINDOWS"]="A fan remake of Zelda II: The Adventure of Link with modern upgrades."
    ["TLOZ-DUNGEONS-OF-INFINITY/WINDOWS"]="A Zelda 3-style fan game featuring endless dungeons and exploration."
    ["HYDORA/WINDOWS-IN-CONTAINER"]="Hydorah, a classic-style horizontal shoot-'em-up inspired by Gradius."
    ["CRASH-BANDICOOT-BACK-IN-TIME/WINDOWS"]="A free fan game homage to Crash Bandicoot."
    ["MODERN-MODERN-CHEF/WINDOWS"]="A fast-paced indie game where you flip food into the air and catch it."
    ["SONIC-TRIPLE-TROUBLE/WINDOWS"]="A fan remake of the Game Gear title Sonic Triple Trouble for PC."
    ["TMNT-RESCUE-PALOOZA/WINDOWS"]="A massive fan-made TMNT beat-em-up featuring dozens of characters."
    ["MEGA-MAN-AGAIN/WINDOWS"]="A fan-made remake of Mega Man 1 with updated visuals and gameplay."
    ["STREET-FIGHTER-X-MEGA-MAN/WINDOWS"]="A fan-made crossover where Mega Man battles Street Fighter characters."
    ["SONIC-AND-THE-FALLEN-STAR/WINDOWS"]="A full-length fan-made Sonic game with original levels and music."
    ["TROGDOR-REBURNIATED/WINDOWS"]="A remastered version of the classic Trogdor game from Homestar Runner."
    ["PullyWogTog/WINDOWS"]="A quirky indie puzzle platformer."
    ["SUPERCRATEBOX/WINDOWS"]="A frantic arcade shooter where collecting crates is the key to survival."
    ["MEGAMAN-ROCK-N-ROLL/LINUX"]="A fan game blending Mega Man and Roll in classic 8-bit style."
    ["GLOBEBA/WINDOWS"]="A small indie adventure game similar to a mini Zelda-like experience."
    ["ROCKBOT/LINUX"]="A free and open-source Mega Man-style action platformer."
    ["ROCKBOT2/LINUX"]="The sequel to Rockbot, continuing the retro action platforming."
    ["ABUSE/LINUX"]="A dark sci-fi side-scrolling shooter from the '90s."
    ["C-DOGS/LINUX"]="A free top-down shooter with campaigns and local multiplayer."
    ["HYDRA-CASTLE-LABYRINTH/LINUX"]="A Japanese indie Metroidvania with retro pixel art."
    ["QUAKE-SHAREWARE/LINUX"]="The shareware version of id Software's classic Quake."
    ["SUPER-BROS-WAR/LINUX"]="A 2D Super Mario-themed fighting game similar to Smash Bros."
    ["SUPERTUXKART/LINUX"]="A free, open-source kart racing game featuring Tux and friends."
    ["TYRIAN/LINUX"]="A vertical-scrolling sci-fi shoot-'em-up from the '90s."
    ["UNVANQUISHED/LINUX"]="A free, fast-paced strategy FPS inspired by Tremulous."
    ["VELOREN/LINUX"]="A free and open-source multiplayer voxel RPG inspired by Cube World."
    ["XRICK/LINUX"]="A clone of the 1989 platformer Rick Dangerous."
    ["ZERO-K/LINUX"]="A free, open-source RTS similar to Total Annihilation."
    ["RI-LI/WINDOWS"]="A colorful train-themed puzzle game."
    ["XMOTO/WINDOWS"]="A physics-based 2D motorbike platforming game."
    ["OPERATION-KYBER-CRYSTAL/LINUX"]="A Star Wars-style dark sci-fi shooter adventure."
    ["FLARE-RPG"]="A free open-source Diablo-style RPG"
)

# === Animated Header ===
clear
animate_border
animate_title
animate_border
display_controls

# === Build Dialog Menu ===
app_list=()
for app in $(printf "%s\n" "${!apps[@]}" | sort); do
    app_list+=("$app" "${descriptions[$app]}" OFF)
done

cmd=(dialog --separate-output --checklist "Select applications to install or update:" 24 120 18)
choices=$("${cmd[@]}" "${app_list[@]}" 2>&1 >/dev/tty)

# === Cancel Handling ===
if [ $? -eq 1 ]; then
    echo "Installation cancelled."
    exit
fi

# === Install Loop ===
needs_pacman_update=false

# Pre-check: Any pacman installs selected?
for choice in $choices; do
    install_cmd="${apps[$choice]}"
    if [[ "$install_cmd" == pacman* ]]; then
        needs_pacman_update=true
        break
    fi
done

# Pacman update once if needed
if $needs_pacman_update; then
    clear
    echo "Updating system packages first (pacman -Syu)..."
    pacman -Syu --noconfirm
fi

# Install each selected app
for choice in $choices; do
    install_cmd="${apps[$choice]}"

    if [[ "$install_cmd" == pacman* ]]; then
        clear
        echo "Installing $choice via pacman..."
        $install_cmd
        echo -e "\n$choice installed.\n"
    else
        applink="$(echo "$install_cmd" | awk '{print $3}')"
        rm /tmp/.app 2>/dev/null
        wget --tries=10 --no-check-certificate --no-cache --no-cookies -q -O "/tmp/.app" "$applink"
        if [[ -s "/tmp/.app" ]]; then 
            dos2unix /tmp/.app 2>/dev/null
            chmod 777 /tmp/.app 2>/dev/null
            clear
            loading_animation
            sed 's,:1234,,g' /tmp/.app | bash
            echo -e "\n$choice installed.\n"
        else 
            echo "Error: couldn't download installer for ${apps[$choice]}"
        fi
    fi
done

# === Refresh Gamelist ===
echo "Update Gamelist to see any additions"

