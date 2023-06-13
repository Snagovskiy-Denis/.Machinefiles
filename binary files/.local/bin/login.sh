#!/bin/bash

shopt -s nullglob globstar

prefix=${PASSWORD_STORE_DIR-~/.password-store}
password_files=( "$prefix"/**/*.gpg )
password_files=( "${password_files[@]#"$prefix"/}" )
password_files=( "${password_files[@]%.gpg}" )

password=$(printf '%s\n' "${password_files[@]}" | dmenu "$@")

[[ -n $password ]] || exit

pass -c2 "${password}"
echo -n "$(xclip -o -sel clip)" | xclip -selection clipboard

xdotool key ctrl+shift+v

sleep 0.5

xdotool key Tab

pass -c "${password}"
echo -n "$(xclip -o -sel clip)" | xclip -selection clipboard

xdotool key ctrl+shift+v

sleep 0.5

xdotool key enter
