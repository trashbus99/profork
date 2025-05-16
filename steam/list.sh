#!/bin/bash

# Create the list of apps in a string, each app as an option
apps=(
"Boilr.sh"
"Bottles.sh"
"Brave.sh"
"Chiaki.sh"
"FileManager-PCManFM.sh"
"Filezilla.sh"
"Firefox.sh"
"Flatpak-Config.sh"
"GameHub.sh"
"Geforce Now.sh"
"Google-Chrome.sh"
"Gparted.sh"
"Greenlight.sh"
"Heroic Game Launcher.sh"
"Lutris.sh"
"Microsoft-Edge.sh"
"Moonlight.sh"
"Minecraft-Bedrock.sh"
"OBS Studio.sh"
"Parsec.sh"
"Peazip.sh"
"Play on Linux 4.sh"
"Protonup-Qt.sh"
"Smplayer.sh"
"Spotify.sh"
"Steam Big Picture Mode.sh"
"Steam Diagnostic.sh"
"Steam.sh"
"SteamTinker Launch (settings).sh"
"Shadps4.sh"
"Terminal-Tabby.sh"
"TigerVNC.sh"
"VLC.sh"
"WineGUI.sh"
)


# Package groups
audio_pkgs="alsa-lib lib32-alsa-lib alsa-plugins lib32-alsa-plugins libpulse lib32-libpulse \
jack2 lib32-jack2 alsa-tools alsa-utils pavucontrol pipewire lib32-pipewire"

video_pkgs="mesa lib32-mesa vulkan-radeon lib32-vulkan-radeon \
vulkan-intel lib32-vulkan-intel nvidia-utils lib32-nvidia-utils wayland \
vulkan-icd-loader lib32-vulkan-icd-loader vulkan-mesa-layers weston \
lib32-vulkan-mesa-layers libva-mesa-driver lib32-libva-mesa-driver \
libva-intel-driver lib32-libva-intel-driver intel-media-driver \
mesa-utils vulkan-tools nvidia-prime libva-utils lib32-mesa-utils"

wine_pkgs="wine-ge-custom winetricks wine-nine wineasio \
giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap \
gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal \
v4l-utils lib32-v4l-utils libpulse lib32-libpulse alsa-plugins \
lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo \
lib32-libjpeg-turbo libxcomposite lib32-libxcomposite libxinerama \
lib32-libxinerama libxslt lib32-libxslt libva lib32-libva gtk3 \
lib32-gtk3 vulkan-icd-loader lib32-vulkan-icd-loader sdl2 lib32-sdl2 \
vkd3d lib32-vkd3d libgphoto2 ffmpeg gstreamer gst-plugins-good gst-plugins-bad \
gst-plugins-ugly gst-plugins-base lib32-gst-plugins-good \
lib32-gst-plugins-base gst-libav wget wine-mono wine-gecko"

devel_pkgs="base-devel git meson mingw-w64-gcc cmake"

# Packages to install
# You can add packages that you want and remove packages that you don't need
# Apart from packages from the official Arch repos, you can also specify
# packages from the Chaotic-AUR repo
export packagelist="${audio_pkgs} ${video_pkgs} ${wine_pkgs} ${devel_pkgs} \
nano ttf-dejavu ttf-liberation steam firefox mpv pcmanfm strace nnn bat \
htop aria2 neofetch xorg-xwayland kdenlive gedit btop ranger \
steam-native-runtime gamemode brave lib32-gamemode jre-openjdk lxterminal \
mangohud shotcut thunderbird gimp audacity thunderbird lib32-mangohud kodi \
qt5-wayland xorg-server-xephyr inkscape openbox obs-studio binutils emby-theater \
xdotool xbindkeys gparted vlc smplayer mpv fish zsh xmlstarlet nvtop duf exa \
minigalaxy legendary gamescope playonlinux minizip flatpak libreoffice \
ripgrep i7z sd bandwhich tre zoxide p7zip atop iftop sysstat totem feh krename \
bottles bauh flatseal rebuild-detector ccache axel breeze xorg-xdpyinfo dua-cli \
handbrake tigervnc remmina  kitty terminator xorg-xkill media-downloader file  \
docker docker-compose portainer-bin unzip gthumb nmon thunar nemo umu-launcher \
gdk-pixbuf-xlib gdk-pixbuf2 xarchiver mc vifm fd deckctl steam-tweaks deck-pref-gui   \
steam-boilr-gui btrfs-assistant protontricks-git lib32-sdl12-compat sdl12-compat appimagepool-appimage  kmod pciutils xrdp x11vnc tigervnc onboard remmina vinagre freerdp sunshine btrfs-progs tre \
podman distrobox cheese filezilla dos2unix wmctrl xorg-xprop fzf scc yarn sdl2 sdl2_image squashfs-tools \
btrfs-heatmap meld lynx yq xorg xorg-server-xvfb nodejs npm cairo-dock imagemagick strace sdl2_mixer python-pysdl2 \
tint2 plank lxde mate mate-extra dialog xterm compsize antimicrox qdirstat lutris-git chiaki procs sdl2_ttf \
protontricks-git chiaki sublime-text-4 fuse2 heroic-games-launcher-bin moonlight-qt zoom ventoy-bin 7-zip crun runc \
microsoft-edge-stable-bin qdirstat peazip jq steam-rom-manager-git google-chrome steamtinkerlaunch xfwm4 xfwm4-themes \
screenfetch glances discord jre8-openjdk gcc13 python-pip xfce4 xfce4-goodies lua53 shadps4-git"
# If you want to install AUR packages, specify them in this variable
export aur_packagelist="geforcenow-electron  mcpelauncher-appimage parsec-bin protonup-qt freefilesync-bin sgdboop-bin winegui-bin"

# Concatenate all packages and sort them alphabetically
all_packages=$(echo "$audio_pkgs $video_pkgs $wine_pkgs $devel_pkgs $packagelist $aur_packagelist" | tr ' ' '\n' | sort | tr '\n' ' ')

# Function to display packages using dialog
show_packages() {
    dialog --backtitle "Package List" \
    --title "All Packages--Jan 12 2025" \
    --msgbox "$all_packages" 20 70
}

# Call the function to display packages
show_packages

# Create the list of apps in a string, each app as an option
apps=(
"Boilr.sh"
"Bottles.sh"
"Brave.sh"
"Chiaki.sh"
"FileManager-PCManFM.sh"
"Filezilla.sh"
"Firefox.sh"
"Flatpak-Config.sh"
"GameHub.sh"
"Geforce Now.sh"
"Google-Chrome.sh"
"Greenlight.sh"
"Heroic Game Launcher.sh"
"Lutris.sh"
"Microsoft-Edge.sh"
"Moonlight.sh"
"Minecraft-Bedrock.sh"
"OBS Studio.sh"
"Parsec.sh"
"Peazip.sh"
"Protonup-Qt.sh"
"Smplayer.sh"
"Spotify.sh"
"Steam Big Picture Mode.sh"
"Steam Diagnostic.sh"
"Steam.sh"
"SteamTinker Launch (settings).sh"
"Shadps4.sh"
"Terminal-Tabby.sh"
"TigerVNC.sh"
"VLC.sh"
"WineGUI.sh"
)

# Use dialog to display the list in a message box
dialog --title "Container Apps Available via EmulationStation" --msgbox "$(printf '%s\n' "${apps[@]}")" 30 55

# Ensure the terminal window is cleared after dialog closes
clear


curl -Ls https://github.com/trashbus99/profork/raw/master/steam/steam.sh | bash
