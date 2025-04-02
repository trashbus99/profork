#!/bin/bash

# Marker file
PASS_FILE="/userdata/system/pro/pass"

# Check if already passed
if [ -f "$PASS_FILE" ]; then
    echo "✅ SBC quiz previously passed. Launching ARM64 Tools Menu..."
    sleep 1
    curl -Ls https://github.com/trashbus99/profork/raw/master/app/arm_menu.sh | bash
    echo "Thanks for playing! You've earned the right to scoff at overpriced SBCs."
    echo "Now go get an N100, or maybe even something better."
    exit 0
fi

# Set up music paths
MUSIC_DIR="/userdata/music"
mkdir -p "$MUSIC_DIR"

# MP3 URLs
declare -A MP3S=(
    ["$MUSIC_DIR/jeopardy.mp3"]="https://github.com/trashbus99/profork/raw/master/.dep/.ytrk/at.mp3"
    ["$MUSIC_DIR/rickroll.mp3"]="https://github.com/trashbus99/profork/raw/master/.dep/.ytrk/ee.mp3"
    ["$MUSIC_DIR/loserhorn.mp3"]="https://github.com/trashbus99/profork/raw/master/.dep/.ytrk/lh.mp3"
    ["$MUSIC_DIR/comeondown.mp3"]="https://github.com/trashbus99/profork/raw/master/.dep/.ytrk/cod.mp3"
    ["$MUSIC_DIR/win.mp3"]="https://github.com/trashbus99/profork/raw/master/.dep/.ytrk/win.mp3"
)

# Download MP3s if missing
for file in "${!MP3S[@]}"; do
    [ -f "$file" ] || wget -q -O "$file" "${MP3S[$file]}"
done

# Infinite loop for retry logic
while true; do

    clear
    echo "============================================="
    echo "  WELCOME TO THE BATOCRA SBC POP QUIZ!"
    echo "============================================="
    sleep 1

    # Play intro
    MUSIC_PID=""
    if command -v cvlc >/dev/null 2>&1; then
        cvlc --play-and-exit --no-video "$MUSIC_DIR/comeondown.mp3" >/dev/null 2>&1 &
        MUSIC_PID=$!
    elif command -v mpg123 >/dev/null 2>&1; then
        mpg123 -q "$MUSIC_DIR/comeondown.mp3" &
        MUSIC_PID=$!
    fi

    dialog --msgbox "Welcome to the Batocera SBC Pop Quiz!\n\nPass the quiz to unlock the secret ARM64 tools menu.\n\nGet all 7 questions correct or try again. Good luck!" 11 60
    kill "$MUSIC_PID" 2>/dev/null

    # Play Jeopardy music
    if command -v cvlc >/dev/null 2>&1; then
        cvlc --play-and-exit --no-video "$MUSIC_DIR/jeopardy.mp3" >/dev/null 2>&1 &
        MUSIC_PID=$!
    elif command -v mpg123 >/dev/null 2>&1; then
        mpg123 -q "$MUSIC_DIR/jeopardy.mp3" &
        MUSIC_PID=$!
    fi

    score=0
    total=7

    # Quiz questions
    ans1=$(dialog --stdout --menu "Q1: What's the problem with the Raspberry Pi 5's GPU?" 15 60 4 \
        A "Uses VideoCore still — no Vulkan, weak GL" \
        B "Runs Crysis" C "Amazing for PS2 emulation" D "NVIDIA drivers supported")
    [ "$ans1" == "A" ] && ((score++))

    ans2=$(dialog --stdout --menu "Q2: What's the current state of Panfrost drivers on Orange PI 5?" 15 60 4 \
        A "OpenGL is buggy, Vulkan worse" B "Better than libMali" \
        C "Plays Spider-Man flawlessly" D "Fully supported with ray tracing")
    [ "$ans2" == "A" ] && ((score++))

    ans3=$(dialog --stdout --menu "Q3: Which is the best GPU driver for Mali G610?" 15 60 4 \
        A "Android" B "Rocknix with libMali blob" \
        C "Batocera with Panfrost" D "Pi with dreams")
    [ "$ans3" == "A" ] && ((score++))

    ans4=$(dialog --stdout --menu "Q4: What's a better deal than Pi5 and accesories \$120?" 15 60 4 \
        A "N100 mini PC" B "\$50 OptiPlex" \
        C "AliExpress handheld" D "All of the above")
    [ "$ans4" == "D" ] && ((score++))

    ans5=$(dialog --stdout --menu "Q5: What can’t you run on a Pi5 with Batocera?" 15 60 4 \
        A "PS2/GameCube reliably" B "Wine games" \
        C "32-bit Portmaster" D "All of the above")
    [ "$ans5" == "D" ] && ((score++))

    ans6=$(dialog --stdout --menu "What's the proper Response to Pi hype?" 15 60 4 \
        A "Get an N100." B "Try Android" \
        C "Overclock and pray" D "It's about the vibes")
    [ "$ans6" == "A" ] && ((score++))

    ans7=$(dialog --stdout --menu "What's the Best thing about x86 SFF PCs?" 15 60 4 \
        A "Wine, desktop apps, full emulation" B "Cool BIOS" \
        C "RGB headers" D "No AliExpress spam")
    [ "$ans7" == "A" ] && ((score++))

    kill "$MUSIC_PID" 2>/dev/null

    # Handle results
    if [ "$score" -eq "$total" ]; then
        # Win
        mkdir -p "/userdata/system/pro"
        touch "$PASS_FILE"

        if command -v cvlc >/dev/null 2>&1; then
            cvlc --play-and-exit --no-video "$MUSIC_DIR/win.mp3" >/dev/null 2>&1 &
        elif command -v mpg123 >/dev/null 2>&1; then
            mpg123 -q "$MUSIC_DIR/win.mp3" &
        fi

        dialog --msgbox "🥳 You survived the SBC quiz!

        Not everyone can admit they bought a Pi5 *and* still deserve tools.

        Enjoy your humble reward — the ARM64 Tools Menu. Just don’t expect PS2 to run." 15 60

        sleep 1
        curl -Ls https://github.com/trashbus99/profork/raw/master/app/arm_menu.sh | bash
        exit 0

    else
        # Fail
        if command -v cvlc >/dev/null 2>&1; then
            cvlc --play-and-exit --no-video "$MUSIC_DIR/loserhorn.mp3" >/dev/null 2>&1 &
        elif command -v mpg123 >/dev/null 2>&1; then
            mpg123 -q "$MUSIC_DIR/loserhorn.mp3" &
        fi

        dialog --msgbox "💀 WOMP WOMP.\n\nScore: $score/$total\nYou Pi'd when you should’ve Mini PC’d." 13 60

        dialog --yesno "Would you like to try again?" 8 40
        response=$?
        if [ $response -eq 1 ]; then
            clear
            echo "Fair enough. You're not ready yet."
            echo "Maybe go check eBay for a used SFF OptiPlex or an N100 mini pc and reflect on your life."
            sleep 4
            exit 1
        fi
    fi
done
