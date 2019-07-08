#!/bin/bash

DEVICE='40:ED:98:19:0D:08'

bluetoothctl info $DEVICE | grep 'Connected: yes' \
    || bluetoothctl connect 40:ED:98:19:0D:08
