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
echo "Just kidding. But seriously, watch your back. 👀"
sleep 2
clear

