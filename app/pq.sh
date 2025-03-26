#!/bin/bash

# File paths
JEOPARDY_AUDIO="/userdata/music/jeopardy.mp3"
RICKROLL_AUDIO="/userdata/music/rickroll.mp3"
LOSER_HORN_AUDIO="/userdata/music/loserhorn.mp3"
COME_ON_DOWN_AUDIO="/userdata/music/comeondown.mp3"
WIN_AUDIO="/userdata/music/win.mp3"

# MP3 URLs
JEOPARDY_URL="https://github.com/trashbus99/profork/raw/master/.dep/.ytrk/at.mp3"
RICKROLL_URL="https://github.com/trashbus99/profork/raw/master/.dep/.ytrk/ee.mp3"
LOSER_HORN_URL="https://github.com/trashbus99/profork/raw/master/.dep/.ytrk/lh.mp3"
COME_ON_DOWN_URL="https://github.com/trashbus99/profork/raw/master/.dep/.ytrk/cod.mp3"
WIN_URL="https://github.com/trashbus99/profork/raw/master/.dep/.ytrk/win.mp3"

# Ensure the directory exists
mkdir -p /userdata/music

# Download MP3s if missing
for file in "$JEOPARDY_AUDIO" "$RICKROLL_AUDIO" "$LOSER_HORN_AUDIO" "$COME_ON_DOWN_AUDIO" "$WIN_AUDIO"; do
    case $file in
        "$JEOPARDY_AUDIO") URL="$JEOPARDY_URL" ;;
        "$RICKROLL_AUDIO") URL="$RICKROLL_URL" ;;
        "$LOSER_HORN_AUDIO") URL="$LOSER_HORN_URL" ;;
        "$COME_ON_DOWN_AUDIO") URL="$COME_ON_DOWN_URL" ;;
        "$WIN_AUDIO") URL="$WIN_URL" ;;
    esac
    if [ ! -f "$file" ]; then
        wget -q -O "$file" "$URL"
    fi
done

# Display welcome message
clear
echo "============================================="
echo "  WELCOME TO THE BATOCRA SBC POP QUIZ!"
echo "  Hosted by the Mikhailzrick Institute"
echo "============================================="
sleep 1

# Play Come on Down intro
if command -v cvlc >/dev/null 2>&1; then
    cvlc --play-and-exit --no-video "$COME_ON_DOWN_AUDIO" >/dev/null 2>&1 &
    MUSIC_PID=$!
elif command -v mpg123 >/dev/null 2>&1; then
    mpg123 -q "$COME_ON_DOWN_AUDIO" &
    MUSIC_PID=$!
fi

# Let user advance with a dialog box
dialog --msgbox "Welcome to the Batocera SBC Pop Quiz!\n\nPress ENTER to begin..." 10 50
kill "$MUSIC_PID" 2>/dev/null

# Play Jeopardy music in background
if command -v cvlc >/dev/null 2>&1; then
    cvlc --play-and-exit --no-video "$JEOPARDY_AUDIO" >/dev/null 2>&1 &
    MUSIC_PID=$!
elif command -v mpg123 >/dev/null 2>&1; then
    mpg123 -q "$JEOPARDY_AUDIO" &
    MUSIC_PID=$!
fi

score=0

# Questions
ans1=$(dialog --stdout --menu "Q1: What's the problem with the Raspberry Pi 5's GPU?" 15 60 4 \
A "Uses VideoCore still — no Vulkan, weak GL" \
B "Runs Crysis" \
C "Amazing for PS2 emulation" \
D "NVIDIA drivers supported")
[ "$ans1" == "A" ] && ((score++))

ans2=$(dialog --stdout --menu "Q2: What's the current state of Panfrost drivers on OPI5?" 15 60 4 \
A "OpenGL is buggy, Vulkan worse" \
B "Better than libMali" \
C "Plays Spider-Man flawlessly" \
D "Fully supported with ray tracing")
[ "$ans2" == "A" ] && ((score++))

ans3=$(dialog --stdout --menu "Q3: Which platform has the best GPU driver for Mali G610?" 15 60 4 \
A "Android" \
B "Rocknix with libMali blob" \
C "Batocera with Panfrost" \
D "Raspberry Pi with dreams")
[ "$ans3" == "A" ] && ((score++))

ans4=$(dialog --stdout --menu "Q4: What’s a better deal than a Pi5 + parts for \$120+?" 15 60 4 \
A "N100 mini PC" \
B "\$50 eBay OptiPlex" \
C "AliExpress handheld that runs PS2 (but not cheap)" \
D "All of the above")
[ "$ans4" == "D" ] && ((score++))

ans5=$(dialog --stdout --menu "Q5: What can you *not* run on a Raspberry Pi 5? on Batocera" 15 60 4 \
A "PS2 and GameCube reliably" \
B "Windows EXEs through Wine on Batocera" \
C "32bit Portmaster games" \
D "All of the above")
[ "$ans5" == "D" ] && ((score++))

ans6=$(dialog --stdout --menu "Bonus: What's Mikhalzrick's favorite response to Pi hype?" 15 60 4 \
A "Get an N100." \
B "Try it on Android." \
C "Overclock it and pray." \
D "It’s not about the specs, it’s about the vibes.")
[ "$ans6" == "A" ] && ((score++))

ans7=$(dialog --stdout --menu "Bonus: What's the biggest advantage of x86 SFF PCs?" 15 60 4 \
A "Can run Wine, full desktop apps, better emulation" \
B "Cooler BIOS menus" \
C "RGB headers included" \
D "You can’t buy them at AliExpress")
[ "$ans7" == "A" ] && ((score++))

# Kill Jeopardy music before showing results
kill "$MUSIC_PID" 2>/dev/null

# Results
total=7
if [ $score -eq $total ]; then
    if command -v cvlc >/dev/null 2>&1; then
        cvlc --play-and-exit --no-video "$WIN_AUDIO" >/dev/null 2>&1 &
    elif command -v mpg123 >/dev/null 2>&1; then
        mpg123 -q "$WIN_AUDIO" &
    fi
    dialog --msgbox "🎉 PERFECT SCORE! 🎉\n\nYou passed the Mikhailzrick SBC Showdown!\nScore: $score/$total\n\n✅ You are SBC-literate.\n🏆 Enjoy your dusty OptiPlex victory lap!" 15 60
elif [ $score -ge 4 ]; then
    dialog --msgbox "Not bad!\n\nScore: $score/$total\nYou avoided the loser horn, but you’re not quite out of the pi cult yet.\n\nKeep studying those Mali drivers!" 15 60
else
    if command -v cvlc >/dev/null 2>&1; then
        cvlc --play-and-exit --no-video "$LOSER_HORN_AUDIO" >/dev/null 2>&1 &
    elif command -v mpg123 >/dev/null 2>&1; then
        mpg123 -q "$LOSER_HORN_AUDIO" &
    fi
    dialog --msgbox "WOMP WOMP.\n\nScore: $score/$total\nYou Pi'd when you should’ve Mini PC’d.\n\nMay your next SBC be a lesson." 15 60
fi

# Clean up audio
rm -f "$JEOPARDY_AUDIO" "$RICKROLL_AUDIO" "$LOSER_HORN_AUDIO" "$COME_ON_DOWN_AUDIO" "$WIN_AUDIO"
clear

echo "Thanks for playing! You've earned the right to scoff at overpriced SBCs."
echo "Now go get an N100, or maybe even something better."
sleep 5
exit 0

