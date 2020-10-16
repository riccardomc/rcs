#!/bin/bash

SCRIPT=$(basename $0)
BROWSER=$(which brave-browser)

i3popup() {
    notify-send -t 5000 "$SCRIPT: $1"
}

i3popup $1

case "$1" in

start)

    i3-msg "workspace 2; exec gnome-terminal"

    sleep 0.2

    i3-msg "workspace 1; \
            exec slack;\
            exec $BROWSER \
                https://calendar.google.com \
                https://mail.google.com/ \
                https://kanbanflow.com/board/PvQU1A \
                https://web.whatsapp.com/;" &
    ;;

stop)
    pkill "$BROWSER"
    pkill slack
    pkill zim
    pkill keepassx
    ;;


*)
    echo "$0 <start|stop>"
    ;;

esac

i3popup "done"
