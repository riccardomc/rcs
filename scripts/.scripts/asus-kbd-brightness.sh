#!/bin/bash

LEVEL=2
DBUS_PATH='/org/freedesktop/UPower/KbdBacklight'
DBUS_MESSAGE='org.freedesktop.UPower.KbdBacklight.SetBrightness'

case $1 in
    on)
        LEVEL=3
    ;;
    off)
        LEVEL=0
    ;;
    esac



dbus-send --type=method_call \
          --print-reply=literal \
          --system \
          --dest="org.freedesktop.UPower" ${DBUS_PATH} ${DBUS_MESSAGE} int32:${LEVEL}
