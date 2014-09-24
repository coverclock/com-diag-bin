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
if [ "${DEVCSN}" != "" ]; then
    DEVICE="-s ${DEVCSN}"
fi
PATTERN="pppd nodetach noauth noipdefault notty ${SELFIP}:${DEVCIP}"
PIDS="`pgrep -f \"${PATTERN}\"`"
for PID in ${PIDS}; do
    sudo kill ${PID}
done
sudo adb ${DEVICE} shell pkill pppd
sudo iptables-save | grep -v ${RULEID} | sudo iptables-restore
