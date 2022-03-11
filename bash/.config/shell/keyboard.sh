#!/bin/sh

# without x session \ inside TTY

if [ -z "${DISPLAY}" ]; then
    # switch ESC and CapsLock
    filename=/tmp/.keystrings
    printf "keycode 1 = Caps_Lock\nkeycode 58 = Escape\n" > ${filename}
    # visudo NOPASSWD: /urs/bin/loadkeys /tmp/.keystrings
    sudo loadkeys $filename
    rm $filename
else
    # x session

    # layouts and layout switch button
    setxkbmap us,ru -option grp:menu_toggle

    # compose key
    #setxkbmap -option compose:rctrl

    # alone <CapsLock> sends <Escape>
    # <CapsLock> plus another_key sends <Control-another_key>
    setxkbmap -option ctrl:nocaps
    xcape -e 'Control_L=Escape'

    # # alone <Space> sends <Space>
    # # <Space> plus another_key sends <Super-another_key>
    # [[ -f "$HOME/.config/.Xmodmap" ]] && xmodmap $HOME/.config/.Xmodmap

    # spare_modifier="Hyper_L"
    # xmodmap -e "keycode 65 = $spare_modifier"
    # xmodmap -e "add Hyper_L = $spare_modifier"
    # xmodmap -e "keycode any = space"
    # xcape -e "$spare_modifier=space"
fi
