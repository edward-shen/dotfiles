#!/usr/bin/env sh

~/.screenlayout/right_vert.sh

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

feh --bg-fill --no-fehbg ~/.bg.png &
xss-lock -- betterlockscreen -l blur &
dunst &
picom &
pasystray &
nm-applet &
osu-tablet
setxkbmap -option compose:rctrl
eval $(ssh-agent) &
exec i3
