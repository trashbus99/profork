#!/bin/bash

# Check for dialog
if ! command -v dialog >/dev/null; then
    echo "❌ This script requires 'dialog'. Please install it first."
    exit 1
fi

tempfile=$(mktemp)

# Opening prompt
dialog --title "BUA Secret Menu Cracker v2" --msgbox "Welcome to the emotional autopsy of Secret Menu v2.\n\nThis is not just a script. It's therapy masquerading as terminal access.\n\nPress OK to continue..." 10 60
clear

# Begin technical exposure
echo "🧠 Dissecting 'secret.sh' from Secret Menu v2..."
sleep 5

echo
echo "📦 Observed Behavior:"
echo "- Fake license block with emojis and emotional disclaimers"
echo "- Password prompt using 'dialog --passwordbox'"
echo "- curl request to: https://secret.batoaddons.app/scripts.php?pw=PASSWORD"
echo "- Executes remote script using: bash -c"
echo

sleep 5

echo "🔍 Analysis:"
echo "- No real features shown"
echo "- No source code included"
echo "- Password 'security' is purely theatrical"
echo "- Remote payload is hidden, unverifiable, and behind Cloudflare"
echo

sleep 5

# Show sample of the real logic
echo "📄 Core Mechanism:"
echo 'password=$(dialog --passwordbox "Enter the secret password:" 8 40 2>&1 >/dev/tty)'
echo 'menu_script=$(curl -fsSL "https://secret.batoaddons.app/scripts.php?pw=${password}")'
echo 'bash -c "$menu_script"'
echo
sleep 5

# Midpoint dialog moment
dialog --title "Decoded Reality" --msgbox "What we have here is not a toolset.\n\nIt's a cyber safe space — handcrafted, password-locked, and wrapped in bash." 10 55

# Continued echo narration
clear
echo "🔓 You've now seen through it:"
echo "- There is no 'menu'"
echo "- There is no 'tool'"
echo "- Only the illusion of importance"
echo
sleep 5

# The punchline - pretend password unlock
dialog --passwordbox "Enter the password to unlock the inner child:" 8 50 2>"$tempfile"
password=$(<"$tempfile")

echo
echo "🔐 Authenticating password..."
sleep 1
echo "✨ Feelings validated. Curling illusion..."
sleep 2
echo "🫧 Running bash -c on imaginary content..."
sleep 2
echo "✅ Success: Nothing of value was loaded."

# Play Pretending or show cue
echo
echo "🎵 Playing: Mister Rogers – Pretending"
if command -v cvlc >/dev/null; then
    cvlc --play-and-exit "https://github.com/trashbus99/profork/raw/refs/heads/master/.dep/.ytrk/pretend.mp3" &>/dev/null
else
    echo "🔗 https://github.com/trashbus99/profork/rawmaster/.dep/.ytrk/pretend.mp3"
    echo "🎶 (Pretending would be playing now...)"
fi

echo
echo "💫 It’s good to pretend."
echo "🧸 See you in Secret Menu v3."
rm -f "$tempfile"
