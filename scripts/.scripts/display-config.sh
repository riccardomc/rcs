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
    home)
        xrandr --output eDP1 --mode 2560x1440
        xrandr --output HDMI1 --mode 2560x1440 --right-of eDP1 --primary
        ;;
    4k)
        xrandr --output eDP1 --mode 2560x1440
        xrandr --output HDMI1 --mode 3840x2160 --right-of eDP1 --primary
        ;;
    *)
        xrandr --auto
        xrandr --output eDP1 --mode 2560x1440 --primary
        ;;
esac

feh --bg-fill ~/Pictures/wallpaper.jpg || true
i3-msg restart
