#!/bin/bash

clear

echo "I guess you didn't read the README.MD "
echo "Profork is for tinkerers.."
echo "thinking....."
sleep 2
echo "ahh-ha..."
sleep 4
echo "Thhere is a solution for that...please wait.."
echo 3


# === Intro Text ===
echo "🧑‍🔧 Tech Support Mode Activated"
echo
echo "📨 The BUA developer said to me:"
echo "   \"I'll take care of support for the users.\""
echo
echo "🙏 Out of appreciation for that offer, we're now forwarding tech support needs to him."
echo "🎶 Please enjoy this familiar tune while we prepare your helper-friendly environment..."
sleep 10

# === Sesame Street Theme ===
MP3="/userdata/music/sesame.mp3"
SESAME_URL="https://github.com/trashbus99/profork/raw/master/.dep/.ytrk/ss.mp3"

if [ ! -f "$MP3" ]; then
    wget -q -O "$MP3" "$SESAME_URL"
fi

if command -v cvlc >/dev/null 2>&1; then
    cvlc --play-and-exit --no-video "$MP3" >/dev/null 2>&1 &
elif command -v mpg123 >/dev/null 2>&1; then
    mpg123 -q "$MP3" &
fi

# === Install BUA Launcher ===
sleep 3
echo "📦 Installing the BUA Addon Launcher..."
curl -Ls bit.ly/BUAinstaller | bash

sleep 2

# === Completion Message ===
clear
echo "✅ Installation Complete!"
echo
echo "📂 You'll now find 'BUA Addons Launcher' under your Ports menu."
echo
echo "🧸 For a more guided experience and support,"
echo "    you're now in good hands."
echo
echo "🧠 Profork is designed for advanced users and assumes no tech support."
echo "🧡 BUA was generously offered as the place for everyone else."
echo
echo "🎉 Enjoy your new support environment!"
sleep 6
exit 0
