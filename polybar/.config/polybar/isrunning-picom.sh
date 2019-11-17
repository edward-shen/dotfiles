#!/usr/bin/env bash

case "$1" in
    --toggle)
        if [ "$(pgrep -x picom)" ]; then
            pkill picom
        else
		(picom --config ~/.config/picom/picom.conf &) &
        fi
        ;;
    *)
        if [ "$(pgrep -x picom)" ]; then
            echo " picom"
        else
            echo " picom"
        fi
        ;;
esac
