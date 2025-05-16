#!/bin/bash

# Directory to save web apps
webappsDir=~/webapps

# Function to check if the website is reachable
isWebsiteReachable() {
    response=$(curl -o /dev/null -s -w "%{http_code}" "$1")
    if [[ "$response" =~ ^(200|301|302)$ ]]; then
        return 0 # Reachable
    else
        return 1 # Not reachable
    fi
}

# Prompt for URL
url=$(dialog --title "Enter URL" --inputbox "Enter a URL including http/s:" 8 40 3>&1 1>&2 2>&3 3>&-)

# Check if the website is reachable
if ! isWebsiteReachable "$url"; then
    dialog --title "Website Unreachable" --yesno "The website is unreachable. Do you want to continue anyway?" 7 50
    if [ $? -ne 0 ]; then
        exit 1
    fi
fi

# Ensure the webapps directory exists
mkdir -p "$webappsDir"

# Extract domain name for app name
appName=$(echo "$url" | awk -F/ '{print $3}' | sed 's/www\.//')

# Prompt the user to choose a user agent
userAgentChoice=$(dialog --title "Choose User Agent" --menu "Choose a user agent:" 15 50 4 \
1 "Google Chrome" \
2 "Firefox" \
3 "Xbox" \
4 "Google TV" 3>&1 1>&2 2>&3 3>&-)

# Set the user agent string based on the choice
case $userAgentChoice in
    1) userAgent="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3" ;;
    2) userAgent="Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:66.0) Gecko/20100101 Firefox/66.0" ;;
    3) userAgent="Mozilla/5.0 (compatible; MSIE 10.0; Windows NT 6.2; Trident/6.0; Xbox)" ;;
    4) userAgent="Mozilla/5.0 (Linux; Android 9; Google TV Build/PI) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/84.0.4147.89 Safari/537.36" ;;
    *) echo "Invalid choice"; exit 1 ;;
esac

# Create web app with Nativefier
nativefier "$url" -n "$appName" --user-agent "$userAgent" --electron-version $(npm show electron version) "$webappsDir"

# Choose where to save the launcher script
choice=$(dialog --title "Save Location" --menu "Choose where to save the launcher script:" 15 50 4 \
1 "Ports" \
2 "Webapps" 3>&1 1>&2 2>&3 3>&-)

# Determine save directory
saveDir=""
case $choice in
    1) saveDir="/userdata/roms/ports" ;;
    2) saveDir="/userdata/roms/webapps" ;;
    *) echo "Invalid choice"; exit 1 ;;
esac

# Ensure save directory exists
mkdir -p "$saveDir"

# Launcher script path
launcherPath="$saveDir/$appName.sh"

# Create launcher script
cat > "$launcherPath" <<EOF
#!/bin/bash
#------------------------------------------------
conty=/userdata/system/pro/steam/conty.sh
#------------------------------------------------
batocera-mouse show
#------------------------------------------------
  "\$conty" \
          --bind /userdata/system/containers/storage /var/lib/containers/storage \
          --bind /userdata/system/flatpak /var/lib/flatpak \
          --bind /userdata/system/etc/passwd /etc/passwd \
          --bind /userdata/system/etc/group /etc/group \
          --bind /var/run/nvidia /run/nvidia \
          --bind /userdata/system /home/batocera \
          --bind /sys/fs/cgroup /sys/fs/cgroup \
          --bind /userdata/system /home/root \
          --bind /etc/fonts /etc/fonts \
          --bind /userdata /userdata \
          --bind /newroot /newroot \
          --bind / /batocera \
  bash -c 'prepare && dbus-run-session "/userdata/system/webapps/$appName-linux-x64/$appName" --no-sandbox "\${@}"'
#------------------------------------------------
# batocera-mouse hide
#------------------------------------------------
EOF

# Make the launcher script executable
chmod +x "$launcherPath"

echo "Web app $appName created and launcher script saved to $launcherPath."
sleep 3
curl http://127.0.0.1:1234/reloadgames
