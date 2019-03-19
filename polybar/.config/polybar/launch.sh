#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes has been shut down
while pgrep -u $UID -x polybar > /dev/null; do sleep 1; done

# Launch our bars...
polybar top &
polybar bottom &

