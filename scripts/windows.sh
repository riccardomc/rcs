#!/bin/bash

set -e

name='Windows-Desktop'
http_port=8888
username='Administrator'

json=`aws ec2 describe-instances --filters Name=tag:Name,Values=${name}`
instance=`echo $json | jq '.["Reservations"][0]["Instances"][0]'`
state=`echo $instance | jq -r '.["State"]["Name"]'`
id=`echo $instance | jq -r '.["InstanceId"]'`

case "$1" in 
    stop)
        echo "stopping instance"
        aws ec2 stop-instances --instance-ids ${id}
        exit 0
        ;;
    get)
        ip=`echo ${instance} | jq -r '.["NetworkInterfaces"][0]["Association"]["PublicIp"]'`
        url="http://$ip:$http_port/"
        if [[ -z "$2" ]] ; then
            curl -s $url  | grep '^<li>.*'  | sed "s|^<li><a href=\".*\">\(.*\)</a>$|$url\1|"
        else
            echo Downloading "$url/$2"
            curl -o "$2" "$url/$2"
        fi
        exit 0
        ;;
esac


if [ "${state}" == 'running' ] ; then
    resolution=`xrandr | grep "\*" | awk '{printf ("%s\n", $1)}' | sort | uniq | tail -n 1`
    w=`echo ${resolution} | sed 's/x[0-9]*//'`
    h=`echo ${resolution} | sed 's/[0-9]*x//'`
    ip=`echo ${instance} | jq -r '.["NetworkInterfaces"][0]["Association"]["PublicIp"]'`
    echo xfreerdp +clipboard /u:${username} /w:$(( $w  - 10 )) /h:$(( $h - 30 )) /v:${ip}
    xfreerdp +clipboard /u:Administrator /w:$(( $w  - 10 )) /h:$(( $h - 30 )) /v:${ip}

elif [ "${state}" == 'stopped' ] ; then
    echo "starting instance"
    aws ec2 start-instances --instance-ids ${id}
elif [ "${state}" == 'pending' ] ; then
    echo "pending"
else
    echo terminated, or something
fi
