#!/bin/bash

i3popup() {
    notify-send -t 5000 "Background applications: $1"
}


i3popup $1

case "$1" in 

start)
    dropbox start &
    insync start &
    clipit &
    redshift-gtk &
    blueman-applet & 
    ;;

stop)
    dropbox stop &
    insync quit &
    pkill clipit
    pkill redshift-gtk
    pkill blueman-applet 
    ;;

*)
    echo "$0 <start|stop>"
    ;;

esac

i3popup "done"
