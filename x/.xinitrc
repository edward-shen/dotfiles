#!/usr/bin/env sh

feh --bg-scale --no-fehbg ~/.bg.png &
xss-lock -- betterlockscreen -l blur &
dunst &
compton --config ~/.config/compton/compton.conf &
osu-tablet
libinput-gestures &
setxkbmap -option compose:rctrl
eval $(ssh-agent) &
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
