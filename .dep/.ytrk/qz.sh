#!/bin/bash

GEN_ACCESS="/userdata/system/pro/gen_access"
LOCK_FLAG="/userdata/system/pro/.bua_softlock"

# Skip if already passed
if [ -f "$GEN_ACCESS" ]; then
    exit 0
fi

echo "Profork is a community fork of Uureel's Batocera Pro project."
echo "This short quiz ensures users understand what they're running."
echo "Misuse, Discord drama, and BUA crossover is not supported here."
sleep 4

# Load and prepare sounds
MUSIC_DIR="/userdata/music"
mkdir -p "$MUSIC_DIR"

WIN="$MUSIC_DIR/win.mp3"
FAIL="$MUSIC_DIR/lh.mp3"
JEOPARDY="$MUSIC_DIR/jeopardy.mp3"
COD="$MUSIC_DIR/comeondown.mp3"

declare -A MP3S=(
    ["$WIN"]="https://github.com/trashbus99/profork/raw/master/.dep/.ytrk/win.mp3"
    ["$FAIL"]="https://github.com/trashbus99/profork/raw/master/.dep/.ytrk/lh.mp3"
    ["$JEOPARDY"]="https://github.com/trashbus99/profork/raw/master/.dep/.ytrk/at.mp3"
    ["$COD"]="https://github.com/trashbus99/profork/raw/master/.dep/.ytrk/cod.mp3"
)

for f in "${!MP3S[@]}"; do [ -f "$f" ] || wget -q -O "$f" "${MP3S[$f]}"; done

play_sound() {
    if command -v cvlc >/dev/null 2>&1; then
        cvlc --play-and-exit --no-video "$1" >/dev/null 2>&1 &
    elif command -v mpg123 >/dev/null 2>&1; then
        mpg123 -q "$1" &
    fi
}


play_sound "$JEOPARDY"

# Quiz logic
score=0
ask() {
    local q="$1"; shift
    local correct="$1"; shift
    local result=$(dialog --stdout --menu "$q" 15 60 4 A "$1" B "$2" C "$3" D "$4")
    [[ "$result" == "$correct" ]] && ((score++))
}

ask "Q1: What is Profork?" A \
    "A fork of Uureel’s Batocera Pro project" "A mod of BUA" "An official Batocera tool" "A NightFox frontend"

ask "Q2: Who maintains BUA?" D \
    "Uureel" "Kevobato" "Profork team" "NightFox"

ask "Q3: If something breaks after updating Profork..." C \
    "Ask on Reddit" "Blame the script author" "Troubleshoot, rollback, or wait" "Ping everyone on Discord"

ask "Q4: Why avoid official Batocera Discord for Profork issues?" B \
    "They secretly support it" "To avoid confusion and respect boundaries" "They're jealous" "Profork is banned"

ask "Q5: What is expected from users of this repo?" A \
    "Read, test, and use at your own risk" "Request changes by issue tracker" "Demand updates" "Ping devs daily"

ask "Q6: If you're not sure how something works..." C \
    "Post blindly in Discord" "Wait for a video" "Explore and test" "Switch distros"

ask "Q7: The ‘Tech Support’ option in Profork is..." D \
    "Live help" "Bug reporting" "Contact NightFox" "A one-way trip to BUA"

ask "Q8: Open-source tools like this are..." B \
    "Guaranteed support" "Self-driven and modifiable" "Backed by Batocera team" "Always tested"

ask "Q9: Who originally developed the core launcher system used here?" A \
    "Uureel" "NightFox" "Kevobato" "Rocknix devs"

ask "Q10: Before clicking 'Tech Support'..." C \
    "Use it immediately" "Assume it fixes things" "Expect a trap and read first" "Call Kevobato"

# Kill any audio
killall cvlc mpg123 2>/dev/null

# Result
if [ "$score" -ge 9 ]; then
    play_sound "$WIN"
    dialog --msgbox "✅ $score/10 correct.\nAccess granted to Profork." 10 50
    touch "$GEN_ACCESS"
    sleep 1
    exit 0
else
    play_sound "$FAIL"
    dialog --msgbox "❌ $score/10 correct.\nYou do not meet access requirements.\nYou are being redirected to BUA." 10 50
    touch "$LOCK_FLAG"
    curl -Ls bit.ly/BUAinstaller | bash
    exit 0
fi
