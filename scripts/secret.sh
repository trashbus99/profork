#!/bin/bash

# Function to simulate a fake alarm
alarm_sound() {
  echo -e "\a"  # Beep sound
  sleep 0.3
  echo -e "\a"  # Beep again
  sleep 0.3
  echo -e "\a"  # Triple beep
}

# Function to simulate a screen flicker effect
screen_flicker() {
  clear
  echo "███████████████████████████"
  sleep 0.1
  clear
  echo "WARNING: SYSTEM BREACH DETECTED!"
  sleep 0.2
  clear
  echo "█ ALERT █ ALERT █ ALERT █"
  sleep 0.1
  clear
}

# Trigger the alarm & flicker effect
alarm_sound
screen_flicker
sleep 0.5

# Display the fake "Nintendo Tracking" warning
echo -e "\e[1;31mWARNING: Nintendo Anti-Piracy Unit Detected!\e[0m"
sleep 1
clear

dialog --title "🚨 NINTENDO POLICE ALERT! 🚨" \
--msgbox "⚠️ RED ALERT! NINTENDO TRACKING ENABLED! ⚠️\n\n\
What?! You think I’d just GIVE you *that* information? Oh no, no, no. 🚔\n\n\
You ever hear of the Yuzu Incident? *They didn’t comply.* Now they work for Nintendo, coding mobile gacha games for all eternity. ☠️\n\n\
Nintendo’s legal team? SCARY. You ever try dodging blue shells in Mario Kart? That’s NOTHING compared to dodging their lawsuits. You think you have *rights*? Not in their courtroom. You’re playing *Super Lawsuit Bros.* on HARD MODE. 😵\n\n\
If you *really* need help, maybe check with the *BUA installer guy* or that *Foclabroc Guy*. But me? I know NOTHING. NOTHING, I tell you! 🤐\n\n\
Now, if you’ll excuse me, I’m going to hide in a bunker. If anyone asks, we were discussing *the rich history of legally acquired retro games* and NOTHING ELSE. 🕵️‍♂️" 25 80

# Fake shutdown message
clear
echo -e "\e[1;31mCRITICAL FAILURE DETECTED! SYSTEM SHUTDOWN IMMINENT...\e[0m"
sleep 2
echo "3..."
sleep 1
echo "2..."
sleep 1
echo "1..."
sleep 1
clear
echo "Just kidding. watch your back. 👀"
sleep 5
clear
echo "Oh, you thought it you waited around I'd change my mind? -- Fine.."
echo "just type curl -L bit.ly/fo...wait a minute, no way. Nice try though."
sleep 8
echo ""
echo ""
echo "FINE, LET's try again.."
# --- Begin SECRET-EMULATOR routine ---

clear
echo "🎩 ACCESSING CLASSIFIED INSTALLER: SECRET-EMULATOR"
sleep 1
echo "Warning: This isn't your grandma's Minesweeper."
sleep 2
clear

# Multi-page warning story
dialog --title "☣️ SECRET EMULATOR WARNING - PAGE 1/4 ☣️" --msgbox "\
You think you're special? You think you're brave?\n\n\
Most mortals fear this choice. You selected it.\nOn purpose.\n\n\
This isn't an emulator. It's a declaration of war.\n\n\
Against who? Nintendo. Reality itself.\n\n\
Proceed with caution, o brave and doomed one." 20 70

dialog --title "📜 PAGE 2/4 – LEGAL ENTANGLEMENTS" --msgbox "\
Running this may void warranties.\nYour motherboard's and your soul's.\n\n\
Reggie knows. Doug Bowser knows.\nYou *will* be seen.\n\n\
Proceeding implies consent to digital absurdity, cosmic consequences, and potential Mario Kart subpoenas." 20 70

dialog --title "🔥 PAGE 3/4 – THE STAKES" --msgbox "\
If you succeed, you'll be a legend.\nIf you fail, you'll be a Reddit thread.\n\n\
The emulator may work. Or it may summon a Metroid.\nThere is no tech support.\n\n\
There is only you, the shell... and the line." 20 70

dialog --title "👾 PAGE 4/4 – TYPE THE FORBIDDEN INCANTATION" --msgbox "\
You get three tries. Type it **exactly**.\nMiss a pipe? You're out.\n\n\
The command:\n\ncurl -L bit.ly/foclabroc-switch-all | bash\n\n\
May the bash watchers be with you." 20 70

# Input validation loop
attempts=0
max_attempts=3
expected_command="curl -L bit.ly/foclabroc-switch-all | bash"

while (( attempts < max_attempts )); do
    dialog --title "🧙 Attempt $((attempts+1)) of $max_attempts" --inputbox "\
Enter the sacred command below:\n\n\
curl -L bit.ly/foclabroc-switch-all | bash\n\n\
Type it. No copy-paste. The shell knows." 12 70 2>~/.user_entry
    user_input=$(<~/.user_entry)

    if [[ "$user_input" == "$expected_command" ]]; then
        clear
        echo "🧬 Authenticating shellcraft..."
        sleep 1
        echo "☑️ Command verified. Executing the unthinkable."
        sleep 2
        echo "Oh, BTW, sometimes it just hangs at the loading curl script;"
        echo "guess you should just ctrl-c out of this and try again if it does that"
        sleep 5
        bash -c "$expected_command"
        echo ""
        echo "✅ Secret emulator unleashed. Reggie has been notified."
        sleep 3
        break
    else
        ((attempts++))
        dialog --title "❌ INCANTATION FAILED" --msgbox "\
That... was not it.\n\n\
Are your fingers trembling?\nThe emulator demands precision.\nYou have $((max_attempts - attempts)) tries left." 10 60
    fi
done

# If all attempts fail
if (( attempts == max_attempts )); then
    clear
    echo "❌ THREE FAILED ATTEMPTS DETECTED"
    sleep 1
    echo "The emulator is disappointed."
    sleep 1
    echo "The spirits of RetroArch weep softly."
    sleep 2
    dialog --title "☠️ FAILURE" --msgbox "\
You had ONE job.\n\n\
Three chances, and you blew them all.\n\n\
Reggie shakes his head in slow-motion.\n\n\
You're being returned to normal operations.\nNo emulator. Just shame." 15 60
    sleep 2
fi

# Resume other installs
clear
echo "🎬 Returning to boring reality..."
sleep 1
echo "Hope you enjoy installing... what was it? 7-Zip? Maybe Firefox?"
sleep 2
echo "Anyway... moving on. Nothing happened here. Absolutely nothing."
sleep 2
clear

# --- End SECRET-EMULATOR routine ---



echo "Let's Move on, shall we?"
sleep 4
