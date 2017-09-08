#!/bin/bash

ENABLED=$(xset q | sed -n 's/.*DPMS is \(Enabled\).*/\1/p')

if [ $ENABLED ]
then
 xset -dpms 
 xset s off
 xautolock -disable
else
 xset +dpms 
 xset s on
 xautolock -enable
fi
