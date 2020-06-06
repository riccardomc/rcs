#!/bin/bash

for i in $(seq 0 3) ; do
    echo powersave | tee /sys/devices/system/cpu/cpu"${i}"/cpufreq/scaling_governor
done
