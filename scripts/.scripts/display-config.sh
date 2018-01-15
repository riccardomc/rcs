#!/bin/bash

set -x
set -e 

displays_off() {
    DISPLAYS=$(xrandr | grep ' connected ' | awk '{print $1}')

    for i in $DISPLAYS ; do 
        xrandr --output $i --off
    done
}

displays_off
sleep 0.1

CONFIGURATION=$1
case $CONFIGURATION in 
    auto)
        ~/.scripts/display-config.py
        ;;
    *)
        xrandr --auto
        xrandr --output eDP1 --mode 2560x1440 --primary
        ;;
esac

feh --bg-fill ~/Pictures/wallpaper.jpg || true
~/.scripts/reflow-workspaces.py
i3-msg restart
