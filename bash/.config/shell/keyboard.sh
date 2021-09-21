#!/bin/sh

# without x session
if [ -z "${DISPLAY}" ]; then
    # switch ESC and CapsLock
    filename=/tmp/.keystrings
    #printf "keycode 1 = Caps_Lock\nkeycode 58 = Escape\n" > ${filename}
    #loadkeys $filename 
    #rm $filename
else
    # x session
    # layouts and switch btn
    setxkbmap us,ru -option grp:menu_toggle

    # compose key
    #setxkbmap -option compose:rctrl

    # alone <CapsLock> sends <Escape>
    # <CapsLock> plus another_key sends <Control-another_key>
    setxkbmap -option ctrl:nocaps
    xcape -e 'Control_L=Escape'

    # alone <Space> sends <Escape>
    # <Space> plus another_key sends <Super-another_key>
    xmodmap $HOME/.config/.Xmodmap

    spare_modifier="Hyper_L"
    xmodmap -e "keycode 65 = $spare_modifier"
    xmodmap -e "add Hyper_L = $spare_modifier"
    xmodmap -e "keycode any = space"
    xcape -e "$spare_modifier=space"
fi
