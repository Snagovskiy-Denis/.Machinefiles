#!/bin/sh

# backgroung utilities
numlockx &
nitrogen --restore &
picom &
udiskie --smart-tray &
volumeicon &
unclutter -idle 3 &

# keyboard tweaks
${HOME}/.config/shell/keyboard.sh &

# GUI & TUI applications
if [ ! "${1}" == "NoFgJobs" ]; then
    ${TERMINAL:-alacritty} --title oj -e oj &
    ${TERMINAL:-alacritty} --title taskwarrior -e taskwarrior-tui &
    ${TERMINAL:-alacritty} --title cmus -e cmus &
    #vivaldi-stable &
    anki &
fi
