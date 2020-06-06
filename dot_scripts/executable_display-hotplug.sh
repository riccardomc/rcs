#!/bin/bash

log() {
    logger -t 'display-hotplug' $@
}

LASTFILE=/tmp/display-hotplug.last
SECONDS_WAIT=5 #ignore plug/unplug event within seconds

LAST=0
[ -f $LASTFILE ] && LAST=$(cat $LASTFILE)

NOW=$(date -u +%s)
SECONDS_AGO=$(( NOW - LAST ))
if [ $SECONDS_AGO -ge $SECONDS_WAIT ] ; then
    echo $NOW > $LASTFILE
    log 'plug/unplug event: running'
    sleep 1
    sudo -u rmc /home/rmc/.scripts/display-config.sh auto 2>&1 | log
else
    log 'plug/unplug event: too soon'
fi
