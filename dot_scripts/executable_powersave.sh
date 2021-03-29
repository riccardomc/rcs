#!/bin/bash

# Turn off a bunch of radio things
nmcli radio wwan off
rfkill block bluetooth
ifconfig br-3c921cf1d40f down
ifconfig docker0 down
ifconfig lxcbr0 down

# Set CPU governor to powersave
for i in $(seq 0 3) ; do
    echo powersave | tee /sys/devices/system/cpu/cpu"${i}"/cpufreq/scaling_governor
done
