#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps

if [ -f $sysresources ]; then
    xrdb -merge $sysresources

fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"

fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi


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
xmodmap /home/self/.Xmodmap

spare_modifier="Hyper_L"
xmodmap -e "keycode 65 = $spare_modifier"
xmodmap -e "add Hyper_L = $spare_modifier"
xmodmap -e "keycode any = space"
xcape -e "$spare_modifier=space"


# run my custom desktop environment
numlockx &
nitrogen --restore &
picom &
udiskie --smart-tray &
volumeicon &
exec i3
