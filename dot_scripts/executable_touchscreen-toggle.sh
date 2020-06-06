#!/bin/bash

set -x
set -e

TOUCHSCREEN_ID=$(xinput | grep eGalax | sed 's/^.*id=\([0-9]*\).*$/\1/')
TOUCHSCREEN_STATE=$(xinput list-props $TOUCHSCREEN_ID | grep 'Device Enabled' | sed 's/^.*:.*\([01]\).*$/\1/')

if [[ $TOUCHSCREEN_STATE == 1 ]] ; then
    xinput disable $TOUCHSCREEN_ID
else 
    xinput enable $TOUCHSCREEN_ID
fi
