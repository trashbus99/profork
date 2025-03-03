#!/usr/bin/env bash 
# Check if Xwayland is running
if ! pgrep -x "Xwayland" > /dev/null; then
    echo "❌ Xwayland is not running. Exiting."
    exit 1
fi

# Show a Yes/No confirmation dialog
dialog --title "X-Minecraft Launcher" --yesno "X-Minecraft is Experimental on Batocera. Bugs may occur.\n\nContinue installing?" 8 50

# Capture the exit status of the dialog (Yes=0, No=1)
if [ $? -ne 0 ]; then
    echo "Installation canceled by user."
    exit 1
fi

echo "✅ Xwayland detected. Continuing..."
sleep 3

# Define paths
LIBREWOLF_APPIMAGE="/userdata/system/pro/librewolf/librewolf.AppImage"

# Check if Librewolf is installed
if [ ! -f "$LIBREWOLF_APPIMAGE" ]; then
    echo "Browser not found required for sign-in, installing Librewolf..."
    sleep 3
    curl -L https://github.com/trashbus99/profork/raw/master/librewolf/install_arm64.sh | bash
fi



######################################################################
# PROFORK/X-Minecraft-Launcher INSTALLER
######################################################################

# Clear the screen after the dialog box is closed
clear

# --------------------------------------------------------------------
# --------------------------------------------------------------------
# --------------------------------------------------------------------
APPNAME=X-MINECRAFT-LAUNCHER # for installer info
appname=xmcl # directory name in /userdata/system/pro/...
AppName=$appname # App.AppImage name
APPPATH=/userdata/system/pro/$appname/$appname.AppImage
#APPLINK=http://PROFORK/app/$appname.AppImage
APPLINK=$(curl -s https://api.github.com/repos/Voxelum/x-minecraft-launcher/releases/latest | jq -r '.assets[] | select(.name | endswith("arm64.AppImage")) | .browser_download_url')
ORIGIN="www.xmcl.app" # credit & info
# --------------------------------------------------------------------
# --------------------------------------------------------------------
# --------------------------------------------------------------------
# --------------------------------------------------------------------
# show console/ssh info: 
clear
echo
echo
echo
echo -e "${X}PREPARING $APPNAME INSTALLER, PLEASE WAIT . . . ${X}"
echo
echo
echo
echo
# --------------------------------------------------------------------
# -- output colors:
###########################
W='\033[0;37m'            # white
#-------------------------#
RED='\033[1;31m'          # red
BLUE='\033[1;34m'         # blue
GREEN='\033[1;32m'        # green
PURPLE='\033[1;35m'       # purple
DARKRED='\033[0;31m'      # darkred
DARKBLUE='\033[0;34m'     # darkblue
DARKGREEN='\033[0;32m'    # darkgreen
DARKPURPLE='\033[0;35m'   # darkpurple
###########################
# console theme
X='\033[0m' # / resetcolor
L=$X
R=$X
# --------------------------------------------------------------------
# prepare paths and files for installation 
# paths:
cd ~/
pro=/userdata/system/pro
mkdir $pro 2>/dev/null
mkdir $pro/extra 2>/dev/null
mkdir $pro/$appname 2>/dev/null
mkdir $pro/$appname/extra 2>/dev/null
# --------------------------------------------------------------------
# -- prepare dependencies for this app and the installer: 
mkdir -p ~/pro/.dep 2>/dev/null && cd ~/pro/.dep && wget --tries=10 --no-check-certificate --no-cache --no-cookies -q -O ~/pro/.dep/dep.zip https://github.com/trashbus99/profork/raw/master/.dep/dep_arm64.zip && yes "y" | unzip -oq ~/pro/.dep/dep.zip && cd ~/
wget --tries=10 --no-check-certificate --no-cache --no-cookies -q -O $pro/$appname/extra/icon.png https://github.com/trashbus99/profork/raw/master/xmcl/extra/xmcl.png; chmod a+x $dep/* 2>/dev/null; cd ~/
chmod 777 ~/pro/.dep/* && for file in /userdata/system/pro/.dep/lib*; do sudo ln -s "$file" "/usr/lib/$(basename $file)"; done
# --------------------------------------------------------------------
# // end of dependencies 
#
# RUN BEFORE INSTALLER: 
######################################################################
killall wget 2>/dev/null && killall $AppName 2>/dev/null && killall $AppName 2>/dev/null && killall $AppName 2>/dev/null
######################################################################
#
# --------------------------------------------------------------------
# show console/ssh info: 
clear
echo
echo
echo
echo -e "${X}PROFORK/$APPNAME INSTALLER${X}"
echo
echo
echo
echo
# --------------------------------------------------------------------
sleep 0.33
# --------------------------------------------------------------------
clear
echo
echo
echo -e "${X}--------------------------------------------------------"
echo -e "${X}PROFORK/$APPNAME INSTALLER${X}"
echo -e "${X}--------------------------------------------------------"
echo
echo
echo
# --------------------------------------------------------------------
sleep 0.33
# --------------------------------------------------------------------
clear
echo
echo -e "${X}--------------------------------------------------------"
echo -e "${X}--------------------------------------------------------"
echo -e "${X}PROFORK/$APPNAME INSTALLER${X}"
echo -e "${X}--------------------------------------------------------"
echo -e "${X}--------------------------------------------------------"
echo
echo
# --------------------------------------------------------------------
sleep 0.33
# --------------------------------------------------------------------
clear
echo -e "${X}--------------------------------------------------------"
echo -e "${X}--------------------------------------------------------"
echo -e "${X}--------------------------------------------------------"
echo -e "${X}PROFORK/$APPNAME INSTALLER${X}"
echo -e "${X}--------------------------------------------------------"
echo -e "${X}--------------------------------------------------------"
echo -e "${X}--------------------------------------------------------"
echo
# --------------------------------------------------------------------
sleep 0.33
echo -e "${X}THIS WILL INSTALL $APPNAME FOR BATOCERA"
echo -e "${X}USING $ORIGIN"
echo
echo -e "${X}$APPNAME WILL BE AVAILABLE IN F1->APPLICATIONS "
echo -e "${X}AND INSTALLED IN /USERDATA/SYSTEM/PRO/$appname"
echo
echo -e "${X}FOLLOW THE BATOCERA DISPLAY"
echo
echo -e "${X}. . .${X}" 
echo
# // end of console info. 
#
#/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\
#
# THIS WILL BE SHOWN ON MAIN BATOCERA DISPLAY:   
function batocera-pro-installer {
APPNAME="$1"
appname="$2"
AppName="$3"
APPPATH="$4"
APPLINK="$5"
ORIGIN="$6"
# -- colors: 
###########################
X='\033[0m'               # 
W='\033[0m'               # 
#-------------------------#
RED='\033[0m'             # 
BLUE='\033[0m'            # 
GREEN='\033[0m'           # 
PURPLE='\033[0m'          # 
DARKRED='\033[0m'         # 
DARKBLUE='\033[0m'        # 
DARKGREEN='\033[0m'       # 
DARKPURPLE='\033[0m'      # 
###########################
# -- display theme:
L=$W
T=$W
R=$RED
B=$BLUE
G=$GREEN
P=$PURPLE
# .
######################################################################
clear
echo
echo
echo
echo -e "${W}PROFORK/${G}$APPNAME${W} INSTALLER ${W}"
echo
echo
echo
echo
# --------------------------------------------------------------------
sleep 0.33
# --------------------------------------------------------------------
clear
echo
echo
echo
echo -e "${W}PROFORK/${W}$APPNAME${W} INSTALLER ${W}"
echo
echo
echo
echo
# --------------------------------------------------------------------
sleep 0.33
# --------------------------------------------------------------------
clear
echo
echo
echo -e "${L}-----------------------------------------------------------------------"
echo -e "${W}PROFORK/${G}$APPNAME${W} INSTALLER ${W}"
echo -e "${L}-----------------------------------------------------------------------"
echo
echo
echo
# --------------------------------------------------------------------
sleep 0.33
# --------------------------------------------------------------------
clear
echo
echo -e "${L}-----------------------------------------------------------------------"
echo -e "${L}-----------------------------------------------------------------------"
echo -e "${W}PROFORK/${W}$APPNAME${W} INSTALLER ${W}"
echo -e "${L}-----------------------------------------------------------------------"
echo -e "${L}-----------------------------------------------------------------------"
echo
echo
# --------------------------------------------------------------------
sleep 0.33
# --------------------------------------------------------------------
clear
echo -e "${L}-----------------------------------------------------------------------"
echo -e "${L}-----------------------------------------------------------------------"
echo -e "${L}-----------------------------------------------------------------------"
echo -e "${W}PROFORK/${G}$APPNAME${W} INSTALLER ${W}"
echo -e "${L}-----------------------------------------------------------------------"
echo -e "${L}-----------------------------------------------------------------------"
echo -e "${L}-----------------------------------------------------------------------"
echo
# --------------------------------------------------------------------
sleep 0.33
echo -e "${W}THIS WILL INSTALL $APPNAME FOR BATOCERA"
echo -e "${W}USING $ORIGIN"
echo
echo -e "${W}$APPNAME WILL BE AVAILABLE IN F1->APPLICATIONS, PORTS "
echo -e "${W}AND INSTALLED IN /USERDATA/SYSTEM/PRO/$APPNAME"
echo
echo -e "${L}- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
# -- check system before proceeding
if [[ "$(uname -a | grep "aarch64")" != "" ]]; then 
:
else
echo
echo -e "${RED}ERROR: SYSTEM NOT SUPPORTED"
echo -e "${RED}YOU NEED BATOCERA AARCH64${X}"
echo
sleep 5
exit 0
# quit
exit 0
fi
#
# -- temp for curl download
temp=/userdata/system/pro/$appname/extra/downloads
rm -rf $temp 2>/dev/null
mkdir $temp 2>/dev/null
#
# --------------------------------------------------------------------
#
echo
echo -e "${G}DOWNLOADING${W} $APPNAME . . ."
sleep 1
echo -e "${T}$APPLINK" | sed 's,https://,> ,g' | sed 's,http://,> ,g' 2>/dev/null
cd $temp
curl --progress-bar --remote-name --location "$APPLINK"
cd ~/
mv $temp/* $APPPATH 2>/dev/null
chmod a+x $APPPATH 2>/dev/null
rm -rf $temp/*.AppImage
SIZE=$(($(wc -c $APPPATH | awk '{print $1}')/1048576)) 2>/dev/null
echo -e "${T}$APPPATH ${T}$SIZE( )MB ${G}OK${W}" | sed 's/( )//g'



#-----------------------------------
echo -e "${G}> ${W}DONE"
echo
echo -e "${L}- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -"
sleep 1.333
#
# --------------------------------------------------------------------
#
echo
echo -e "${G}INSTALLING ${W}. . ."
# -- prepare launcher to solve dependencies on each run and avoid overlay, 
launcher=/userdata/system/pro/$appname/$appname
rm -rf $launcher
echo '#!/bin/bash ' >> $launcher
echo 'export DISPLAY=:0.0; batocera-mouse show' >> $launcher
## -- APP SPECIFIC LAUNCHER COMMAND: 
######################################################################
######################################################################
###################################################################### 
######################################################################
######################################################################
# Define paths
XMCL_PATH="/userdata/system/pro/xmcl"
LIBREWOLF_APPIMAGE="/userdata/system/pro/librewolf/librewolf.AppImage"
XMCL_APPIMAGE="$XMCL_PATH/xmcl.AppImage"
DEP_PATH="/userdata/system/pro/.dep"

# Create launcher for /userdata/roms/ports/xmcl.sh
cat > /userdata/roms/ports/xmcl.sh << 'EOF'
#!/bin/bash

# Set up display for Batocera
export DISPLAY=:0.0
batocera-mouse show

# Define paths
LIBREWOLF_APPIMAGE="/userdata/system/pro/librewolf/librewolf.AppImage"
XMCL_APPIMAGE="/userdata/system/pro/xmcl/xmcl.AppImage"
DEP_PATH="/userdata/system/pro/.dep"

# Create a fake xdg-open in /tmp so Minecraft uses it for web authentication
export XDG_OPEN_PATH="/tmp/xdg-open"
cat > "$XDG_OPEN_PATH" << 'EOT'
#!/bin/bash
LIBREWOLF_APPIMAGE="/userdata/system/pro/librewolf/librewolf.AppImage"

if echo "$1" | grep -qE '^https?://'; then
    "$LIBREWOLF_APPIMAGE" --appimage-extract-and-run "$1"
else
    echo "xdg-open: Unsupported input: $1"
fi
EOT

# Make it executable
chmod +x "$XDG_OPEN_PATH"

# Export PATH so XMCL finds our custom xdg-open first
export PATH="/tmp:$PATH"

# Launch XMCL
LD_LIBRARY_PATH="$DEP_PATH:${LD_LIBRARY_PATH}" DISPLAY=:0.0 "$XMCL_APPIMAGE" --appimage-extract-and-run --no-sandbox "$@"
EOF

# Make the launcher executable
chmod +x /userdata/roms/ports/xmcl.sh

# Create the additional "Launcher" file in /userdata/system/pro/xmcl/
cat > "$XMCL_PATH/Launcher" << 'EOF'
#!/bin/bash

# Set up display for Batocera
export DISPLAY=:0.0
batocera-mouse show

# Define paths
LIBREWOLF_APPIMAGE="/userdata/system/pro/librewolf/librewolf.AppImage"
XMCL_APPIMAGE="/userdata/system/pro/xmcl/xmcl.AppImage"
DEP_PATH="/userdata/system/pro/.dep"

# Create a fake xdg-open in /tmp so Minecraft uses it for web authentication
export XDG_OPEN_PATH="/tmp/xdg-open"
cat > "$XDG_OPEN_PATH" << 'EOT'
#!/bin/bash
LIBREWOLF_APPIMAGE="/userdata/system/pro/librewolf/librewolf.AppImage"

if echo "$1" | grep -qE '^https?://'; then
    "$LIBREWOLF_APPIMAGE" --appimage-extract-and-run "$1"
else
    echo "xdg-open: Unsupported input: $1"
fi
EOT

# Make it executable
chmod +x "$XDG_OPEN_PATH"

# Export PATH so XMCL finds our custom xdg-open first
export PATH="/tmp:$PATH"

# Launch XMCL
LD_LIBRARY_PATH="$DEP_PATH:${LD_LIBRARY_PATH}" DISPLAY=:0.0 "$XMCL_APPIMAGE" --appimage-extract-and-run --no-sandbox "$@"
EOF

# Make the Launcher file executable
chmod +x "$XMCL_PATH/Launcher"

chmod +x /userdata/roms/ports/xmcl.sh
######################################################################
######################################################################
######################################################################
######################################################################
######################################################################
dos2unix $launcher
chmod a+x $launcher
#### cp $launcher /userdata/roms/ports/Aethersx2.sh 2>/dev/null
cp $launcher /userdata/system/pro/$appname/Launcher 2>/dev/null
# //
# -- get icon for shortcut,
icon=/userdata/system/pro/$appname/extra/icon.png
wget -q -O $icon https://github.com/trashbus99/profork/raw/master/xmcl/extra/xmcl.png
# //
# -- prepare f1 - applications - app shortcut, 
shortcut=/userdata/system/pro/$appname/extra/$appname.desktop
rm -rf $shortcut 2>/dev/null
echo "[Desktop Entry]" >> $shortcut
echo "Version=1.0" >> $shortcut
echo "Icon=/userdata/system/pro/$appname/extra/icon.png" >> $shortcut
echo "Exec=/userdata/system/pro/$appname/$appname %U" >> $shortcut
echo "Terminal=false" >> $shortcut
echo "Type=Application" >> $shortcut
echo "Categories=Game;batocera.linux;" >> $shortcut
echo "Name=$appname" >> $shortcut
f1shortcut=/usr/share/applications/$appname.desktop
cp $shortcut $f1shortcut 2>/dev/null
# //
#
# -- prepare prelauncher to avoid overlay,
pre=/userdata/system/pro/$appname/extra/startup
rm -rf $pre 2>/dev/null
echo "#!/usr/bin/env bash" >> $pre
echo "cp /userdata/system/pro/$appname/extra/$appname.desktop /usr/share/applications/ 2>/dev/null" >> $pre
dos2unix $pre
chmod a+x $pre
# // 
# 
# -- add prelauncher to custom.sh to run @ reboot
customsh=/userdata/system/custom.sh
if [[ -e $customsh ]] && [[ "$(cat $customsh | grep "/userdata/system/pro/$appname/extra/startup")" = "" ]]; then
echo -e "\n/userdata/system/pro/$appname/extra/startup" >> $customsh
fi
if [[ -e $customsh ]] && [[ "$(cat $customsh | grep "/userdata/system/pro/$appname/extra/startup" | grep "#")" != "" ]]; then
echo -e "\n/userdata/system/pro/$appname/extra/startup" >> $customsh
fi
if [[ -e $customsh ]]; then :; else
echo -e "\n/userdata/system/pro/$appname/extra/startup" >> $customsh
fi
dos2unix $customsh 2>/dev/null
# //
#
# -- done. 
sleep 1
echo -e "${G}> ${W}DONE"
echo
sleep 1
echo -e "${L}-----------------------------------------------------------------------"
echo -e "${W}> $APPNAME INSTALLED ${G}OK"
echo -e "${L}-----------------------------------------------------------------------"
sleep 4
}
export -f batocera-pro-installer 2>/dev/null
# --------------------------------------------------------------------
# RUN ALL:
# |
  batocera-pro-installer "$APPNAME" "$appname" "$AppName" "$APPPATH" "$APPLINK" "$ORIGIN"
# --------------------------------------------------------------------
# PROFORK/AETHERSX2 INSTALLER //
#################################
function autostart() {
  csh="/userdata/system/custom.sh"
  pcsh="/userdata/system/pro-custom.sh"
  pro="/userdata/system/pro"
  rm -f $pcsh
  temp_file=$(mktemp)
  find $pro -type f \( -path "*/extra/startup" -o -path "*/extras/startup.sh" \) > $temp_file
  echo "#!/bin/bash" > $pcsh
  sort $temp_file >> $pcsh
  rm $temp_file
  chmod a+x $pcsh
  temp_csh=$(mktemp)
  grep -vxFf $pcsh $csh > $temp_csh
  mapfile -t lines < $temp_csh
  if [[ "${lines[0]}" != "#!/bin/bash" ]]; then
    lines=( "#!/bin/bash" "${lines[@]}" )
  fi
  if ! grep -Fxq "$pcsh &" $temp_csh; then
    lines=( "${lines[0]}" "$pcsh &" "${lines[@]:1}" )
  fi
  printf "%s\n" "${lines[@]}" > $csh
  chmod a+x $csh
  rm $temp_csh
}
export -f autostart
autostart
exit 0
