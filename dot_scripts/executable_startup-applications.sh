#!/bin/bash

i3popup() {
    notify-send -t 5000 "Background applications: $1"
}


i3popup $1

case "$1" in

start)
    insync start &
    diodon &
    /usr/libexec/geoclue-2.0/demos/agent &
    blueman-applet &
    caffeine-indicator &
    ;;

stop)
    insync quit
    pkill diodon
    pkill redshift
    pkill blueman-applet
    pkill -f caffeine-indicator
    ;;

*)
    echo "$0 <start|stop>"
    ;;

esac

i3popup "done"
