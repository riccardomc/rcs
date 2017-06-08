#!/bin/sh

IFIN='eth0'
IFOUT='wlan0'

modprobe ip_tables
modprobe iptable_filter
modprobe iptable_nat
modprobe xt_state
modprobe ipt_MASQUERADE

iptables -F

echo 1 > /proc/sys/net/ipv4/ip_forward

echo iptables -A FORWARD -i $IFOUT -o $IFIN -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i $IFOUT -o $IFIN -m state --state ESTABLISHED,RELATED -j ACCEPT
echo iptables -A FORWARD -i $IFIN -o $IFOUT -j ACCEPT
iptables -A FORWARD -i $IFIN -o $IFOUT -j ACCEPT

echo iptables -t nat -A POSTROUTING -o $IFOUT -j MASQUERADE
iptables -t nat -A POSTROUTING -o $IFOUT -j MASQUERADE
