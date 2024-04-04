#!/bin/bash

# backgroung utilities
numlockx &
nitrogen --restore &
# picom &
udiskie --smart-tray &
volumeicon &
unclutter -idle 3 &

inotify_etl_entrypoint.py etl.daylio ~/sync/default/ 'daylio_export_\d{4}_\d\d_\d\d\.csv' &
inotify_etl_entrypoint.py etl.cronometer ~/download/ 'cronometer_export\.csv' &
inotify_etl_entrypoint.py etl.uhabits ~/sync/habits/ 'Loop Habits Backup \d{4}-\d\d-\d\d.*\.db' &

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
