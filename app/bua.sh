#!/bin/bash

LOCK_FLAG="/userdata/system/pro/.bua_softlock"
PORT_SCRIPT="/userdata/roms/ports/Profork.sh"
MP3="/userdata/music/sesame.mp3"
SESAME_URL="https://github.com/trashbus99/profork/raw/master/.dep/.ytrk/ss.mp3"

# === Confirmation Dialog ===
dialog --title "Notice" \
--yesno "Support is not available for Profork.\n\nThis tool is for advanced users only.\n\nThere are... alternative options for support.\n\nDo you want to proceed anyway?" 14 65

response=$?
if [ "$response" -eq 1 ]; then
    echo "✅ Smart choice. Exiting Profork support menu."
    sleep 2
    exit 0
fi

clear
echo "I guess you didn't read the README.MD "
echo "Profork is for tinkerers..."
echo "thinking....."
sleep 5
echo "ahh-ha..."
sleep 5
echo "There is a solution for that...please wait..."
sleep 3
clear
# === BUA Declaration ===
echo
echo "🧑‍🔧 Tech Support Mode Activated"
sleep 2
echo
echo "📨 The BUA developer said to me:"
echo "   \"I'll take care of support for the users.\""
echo
sleep 2
echo "🙏 Out of appreciation for that offer, we're now forwarding tech support needs to him."
echo "🎶 Please enjoy this familiar tune while we prepare your helper-friendly environment..."
sleep 10

# === Sesame Street Theme ===
if [ ! -f "$MP3" ]; then
    wget -q -O "$MP3" "$SESAME_URL"
fi

if command -v cvlc >/dev/null 2>&1; then
    cvlc --play-and-exit --no-video "$MP3" >/dev/null 2>&1 &
elif command -v mpg123 >/dev/null 2>&1; then
    mpg123 -q "$MP3" &
fi

# === Lock them out ===
touch "$LOCK_FLAG"

# === Remove Profork Launcher ===
if [ -f "$PORT_SCRIPT" ]; then
    echo "🧹 Removing Profork from Ports menu..."
    rm -f "$PORT_SCRIPT"
    sleep 2

    echo "🪪 Replacing with an alternative support solution..."
    cat <<EOF > "$PORT_SCRIPT"
#!/bin/bash
echo "🔒 Profork support has been disabled on this system."
echo "🧸 You're now part of the alternative support environment."
sleep 4
curl -Ls bit.ly/BUAinstaller | bash
EOF

    chmod +x "$PORT_SCRIPT"
    sleep 2
fi

# === Install BUA launcher ===
echo "📦 Installing the BUA Addon Launcher..."
curl -Ls install.batoaddons.app | bash

# === Completion ===
clear
echo "✅ Installation Complete!"
echo
echo "📂 You'll now find 'BUA Addons Launcher' in your Ports menu."
echo
echo "🧠 Profork is a toolkit for advanced users."
echo "🧸 You chose a support-based experience — enjoy!"
sleep 10
killall -9 emulationstation
exit 0
