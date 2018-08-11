#!/bin/bash

i3popup() {
    notify-send -t 5000 "Background applications: $1"
}


i3popup $1

case "$1" in 

start)
    dropbox start &
    ~/.scripts/insync start &
    diodon &
    redshift-gtk &
    blueman-applet & 
    ;;

stop)
    dropbox stop
    ~/.scripts/insync quit
    pkill diodon
    pkill redshift
    pkill blueman-applet 
    ;;

*)
    echo "$0 <start|stop>"
    ;;

esac

i3popup "done"
