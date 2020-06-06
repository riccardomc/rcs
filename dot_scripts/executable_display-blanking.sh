#!/bin/bash

ENABLED=$(xset q | sed -n 's/.*DPMS is \(Enabled\).*/\1/p')

if [ $ENABLED ]
then
 echo disabled
 xset -dpms 
 xset s off
 xautolock -disable
else
 echo enabled
 xset +dpms 
 xset s on
 xautolock -enable
fi
