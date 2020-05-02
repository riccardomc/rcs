#!/bin/bash

log() {
    logger -t 'display-config' $@
}

[ -z $DISPLAY ] && export DISPLAY=':0'

displays_off() {
    DISPLAYS=$(xrandr | grep ' connected ' | grep -v eDP1 | awk '{print $1}')

    for i in $DISPLAYS ; do 
        xrandr --output $i --off || echo off $i failed
    done
}

killall compton
displays_off
sleep 1

CONFIGURATION=$1
case $CONFIGURATION in 
    auto)
        ~/.scripts/display-config.py 2>&1 | log
        ;;
    *)
        xrandr --auto
        xrandr --output eDP1 --mode 2560x1440 --primary
        ;;
esac
sleep 0.5

feh --bg-fill ~/Pictures/wallpaper.png || true
~/.scripts/reflow-workspaces.py 2>&1 | log
i3-msg restart
compton -b
