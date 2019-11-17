#!/usr/bin/env bash

case "$1" in
    --toggle)
        if [ "$(pgrep -x picom)" ]; then
            pkill picom
        else
            (picom &) &
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
