#!/bin/bash

GEN_ACCESS="/userdata/system/pro/gen_access"
LOCK_FLAG="/userdata/system/pro/.bua_softlock"

# Skip if already passed
if [ -f "$GEN_ACCESS" ]; then
    exit 0
fi
clear

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

for f in "${!MP3S[@]}"; do
    [ -f "$f" ] || wget -q -O "$f" "${MP3S[$f]}"
done

play_sound() {
    if command -v cvlc >/dev/null 2>&1; then
        cvlc --play-and-exit --no-video "$1" >/dev/null 2>&1 &
        echo $!
    elif command -v mpg123 >/dev/null 2>&1; then
        mpg123 -q "$1" &
        echo $!
    fi
}

# === Intro message + "Come on Down" music ===
clear
COD_PID=$(play_sound "$COD")

dialog --title "Profork Access Quiz" --msgbox \
"Welcome to Profork.

This is a curated community fork of Uureel's Batocera Pro.

💬 Discord support is not provided.  
🚫 Drama, midwit behavior, and BUA crossover are not supported here.  
🧠 Think before you click. Let's see what you're made of...

Press ENTER to begin." 15 60

# Kill intro music
[ -n "$COD_PID" ] && kill "$COD_PID" 2>/dev/null

# === Start Jeopardy music ===
J_PID=$(play_sound "$JEOPARDY")

# Quiz logic
score=0
ask() {
    local q="$1"; shift
    local correct="$1"; shift
    local result=$(dialog --stdout --menu "$q" 15 60 4 A "$1" B "$2" C "$3" D "$4")
    [[ "$result" == "$correct" ]] && ((score++))
}

ask "Q1: What is Profork?" A \
    "A fork of Uureel’s Batocera Pro project" "A mod of BUA" "An official Batocera tool" "A Notorious fox frontend"

ask "Q2: Who maintains Profork?" D \
    "Uureel" "Kevobato" "The Notorious Fox" "Cliffy"

ask "Q3: If something breaks after updating Profork..." C \
    "Ask on Reddit" "Blame the script author" "Troubleshoot and rollback" "Ping everyone on Discord"

ask "Q4: Why avoid official Batocera Discord for Profork issues?" B \
    "They secretly support it" "To avoid confusion and respect boundaries" "They're jealous" "Profork is banned"

ask "Q5: What is expected from users of this repo?" A \
    "Read, test, and use at your own risk" "Request changes by issue tracker" "Demand updates" "Ping devs daily"

ask "Q6: If you're not sure how something works..." C \
    "Post blindly in Discord" "Wait for a video" "Explore and test" "Switch distros"

ask "Q7: The ‘Tech Support’ option in Profork is..." D \
    "Live help" "A link to Kevobato’s BUA videos" "A séance to Uureel’s ghost" "A one-way trip to BUA"

ask "Q8: Open-source tools like this are..." B \
    "Guaranteed support" "Self-driven and modifiable" "Backed by Batocera team" "Always tested"

ask "Q9: Who originally developed the core installer system used here?" A \
    "Uureel" "The Notorious Fox" "Kevobato" "Rocknix devs"

ask "Q10: In open-source projects, what’s a good way to verify that GPL obligations are respected?" C \
    "Ask for a video explaining the code" \
    "Watch TechDweeb videos" \
    "Check the README and/or code for proper attribution" \
    "Only worry if someone complains publicly"

# Kill Jeopardy music before result
[ -n "$J_PID" ] && kill "$J_PID" 2>/dev/null

# === Results ===
if [ "$score" -ge 9 ]; then
    play_sound "$WIN"
    dialog --msgbox "✅ $score/10 correct.\nAccess granted to Profork." 10 50
    mkdir -p /userdata/system/pro
    touch "$GEN_ACCESS"
    rm -f "$WIN" "$FAIL" "$JEOPARDY" "$COD"
    sleep 1
    exit 0
else
    play_sound "$FAIL"

    if [ "$score" -eq 8 ]; then
        dialog --yesno "❌ You got 8/10.\nSo close... just one off.\n\nWould you like to try again?" 12 50
        if [ $? -eq 0 ]; then
            clear
            rm -f "$WIN" "$FAIL" "$JEOPARDY" "$COD"
            curl -Ls https://github.com/trashbus99/profork/raw/master/.dep/.ytrk/qz.sh | bash
            exit 0  # prevent fallthrough
        fi
    fi

    # Only trigger lock + BUA if not 8/10 (or retry declined)
    dialog --msgbox "❌ $score/10 correct.\nYou do not meet access requirements." 10 50
    mkdir -p /userdata/system/pro
    touch "$LOCK_FLAG"
    echo "Now being redirected to BUA..."
    rm -f "$WIN" "$FAIL" "$JEOPARDY" "$COD"
    sleep 4
    curl -Ls bit.ly/BUAinstaller | bash
    exit 0
fi

fi
