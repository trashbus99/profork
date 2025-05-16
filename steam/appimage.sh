#!/usr/bin/env bash  
# PROFORK INSTALLER FOR STEAM
######################################################################
#--------------------------------------------------------------------- 
#       DEFINE APP INFO >> 
APPNAME=steam 
APPLINK=$(curl -Ls https://api.github.com/repos/ivan-hc/Steam-appimage/releases | grep "browser_download_url.*AppImage" | awk -F '"' '{print $4}' | head -n 1)
APPHOME="github.com/ivan-hc/Steam-appimage"  
#---------------------------------------------------------------------
#       DEFINE LAUNCHER COMMAND >>
COMMAND="mkdir -p /userdata/system/pro/$APPNAME/home /userdata/system/pro/$APPNAME/config /userdata/system/pro/$APPNAME/roms 2>/dev/null; HOME=/userdata/system/pro/$APPNAME/home XDG_CONFIG_HOME=/userdata/system/pro/$APPNAME/config XDG_DATA_HOME=/userdata/system/pro/$APPNAME/home DISPLAY=:0.0 /userdata/system/pro/$APPNAME/$APPNAME.AppImage \"\$1\" \"\$2\" \"\$3\" \"\$4\" \"\$5\" \"\$6\" \"\$7\" \"\$8\" \"\$9\""

# Show installer information
clear 
echo -e "PREPARING $APPNAME INSTALLER, PLEASE WAIT . . ."
# Output colors
X='\033[0m'
W='\033[0m'
GREEN='\033[0m'
RED='\033[0m'
# Prepare paths and files for installation
pro=/userdata/system/pro
mkdir -p $pro 2>/dev/null
mkdir -p $pro/$APPNAME/extra 2>/dev/null
# Save the launcher command
command=$pro/$APPNAME/extra/command
rm -f $command
echo "$COMMAND" > $command

# Fetch and set up dependencies
mkdir -p ~/pro/.dep 2>/dev/null
cd ~/pro/.dep
wget --tries=10 --no-check-certificate --no-cache --no-cookies -q -O dep.zip https://github.com/trashbus99/profork/raw/master/.dep/dep.zip
unzip -oq dep.zip
chmod 777 ~/pro/.dep/*
for file in /userdata/system/pro/.dep/lib*; do
    sudo ln -s "$file" "/usr/lib/$(basename $file)"
done

# Download the Steam AppImage
temp=$pro/$APPNAME/extra/downloads
mkdir -p $temp
cd $temp
curl --progress-bar --remote-name --location "$APPLINK"
mv *AppImage /userdata/system/pro/$APPNAME/$APPNAME.AppImage
chmod a+x /userdata/system/pro/$APPNAME/$APPNAME.AppImage
rm -rf $temp/*.AppImage

# Download and set up icon
wget --tries=10 --no-check-certificate --no-cache --no-cookies -q -O $pro/$APPNAME/extra/icon.png https://github.com/trashbus99/profork/raw/master/steam/extra/icon.png

# Prepare launcher script
launcher=/userdata/system/pro/$APPNAME/Launcher
rm -f $launcher
echo '#!/bin/bash' > $launcher
echo 'unclutter-remote -s' >> $launcher
echo "$(cat $command)" >> $launcher
chmod a+x $launcher
rm $command

# Create .desktop shortcut for Applications menu and Ports
shortcut=/userdata/system/pro/$APPNAME/extra/$APPNAME.desktop
rm -f $shortcut
cat <<EOF >$shortcut
[Desktop Entry]
Version=1.0
Icon=/userdata/system/pro/$APPNAME/extra/icon.png
Exec=/userdata/system/pro/$APPNAME/Launcher
Terminal=false
Type=Application
Categories=Game;batocera.linux;
Name=$APPNAME
EOF
cp $shortcut /usr/share/applications/$APPNAME.desktop
port=/userdata/system/pro/$APPNAME/$APPNAME.sh
cp $launcher $port
chmod a+x $port
cp $port "/userdata/roms/ports/$APPNAME.sh"

# Add launcher to custom.sh for persistence
csh=/userdata/system/custom.sh
if ! grep -q "/userdata/system/pro/$APPNAME/extra/startup" "$csh"; then
    echo "/userdata/system/pro/$APPNAME/extra/startup" >> $csh
fi
dos2unix $csh

# Finish installation
clear
echo "Attention NVIDIA GPU users! Container downloads NVIDIA drivers to ~/local/.share/Conty on first startup and delays startup!"
sleep 10
echo -e "${GREEN}> INSTALLATION COMPLETE. $APPNAME is available in PORTS and the F1->APPLICATIONS MENU.${X}"
echo "REFRESH GAMELIST IN ES"
exit 0
