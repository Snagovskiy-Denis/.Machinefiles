#!/bin/sh
numlockx &
nitrogen --restore &
picom &
udiskie --smart-tray &
volumeicon &

# keyboard tweaks
${HOME}/.config/shell/keyboard.sh &

${TERMINAL:-alacritty} -e oj &
${TERMINAL:-alacritty} -e taskwarrior-tui &
${TERMINAL:-alacritty} -e cmus &
vivaldi-stable &
anki &

#${TERMINAL:-alacritty}
