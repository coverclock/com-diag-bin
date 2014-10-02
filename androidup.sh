#!/bin/bash
# Copyright 2014 by the Digital Aggregates Corporation, Colorado, USA.
# Licensed under the GPLv2.
DEVCIF=${1:-"ppp0"}
SELFIP=${2:-"192.168.1.1"}
DEVCIP=${3:-"192.168.1.2"}
DNS1IP=${4:-"8.8.8.8"}
DNS2IP=${5:-"8.8.4.4"}
DEVCSN=${6:-""}
DEVICE=""
RULEID="ANDROID"
SUFFIX="-m comment --comment ${RULEID}"
if [ "${DEVCSN}" != "" ]; then
    DEVICE="-s ${DEVCSN}"
fi
sudo adb ${DEVICE} root
sudo sysctl net.ipv4.ip_forward=1
sudo iptables -t nat -I POSTROUTING -s ${DEVCIP} -j MASQUERADE -o eth0 ${SUFFIX}
sudo iptables -I FORWARD --in-interface ${DEVCIF} -j ACCEPT ${SUFFIX}
sudo iptables -I INPUT --in-interface ${DEVCIF} -j ACCEPT ${SUFFIX}
sudo adb wait-for-device
sudo adb ${DEVICE} ppp "shell:pppd nodetach noauth noipdefault defaultroute /dev/tty" nodetach noauth noipdefault notty ${SELFIP}:${DEVCIP}
adb ${DEVICE} shell ndc resolver flushif ${DEVCIF}
adb ${DEVICE} shell ndc resolver flushdefaultif
adb ${DEVICE} shell ndc resolver setifdns ${DEVCIF} ${DNS1IP} ${DNS2IP}
adb ${DEVICE} shell ndc resolver setdefaultif ${DEVCIF}
plog
