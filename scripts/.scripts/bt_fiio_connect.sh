#!/bin/bash

DEVICE='40:ED:98:19:0D:08'

notify-send -t 5000 "Connecting FiiO ${DEVICE}"
bluetoothctl info $DEVICE | grep 'Connected: yes' || bluetoothctl connect ${DEVICE}
