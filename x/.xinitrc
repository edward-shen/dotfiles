#!/bin/sh

feh --bg-scale --no-fehbg .bg.png &
xss-lock -- betterlockscreen -l blur &
dunst &
compton &
libinput-gestures &
xsetwacom set "UGEE DECO 01 Pen stylus" MapToOutput DP-1-1
xsetwacom set "UGEE DECO 01 Pen stylus" Area 2560 5500 7680 8440
setxkbmap -option compose:rctrl
eval $(ssh-agent)
exec i3

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
