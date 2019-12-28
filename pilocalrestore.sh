#!/bin/bash
# Copyright 2019 Digital Aggregates Corporation, Arvada CO USA.
# usage: pilocalrestore.sh [ /mnt/pi/hostname [ /mntroot [ /mntboot ] ] ]
# Based on goldilocks via https://raspberrypi.stackexchange.com/questions/5427/can-a-raspberry-pi-be-used-to-create-a-backup-of-itself/28087#28087 .

NAM=$(basename $0 .sh)
BAK=${1:-"/mnt/pi/localhost"}
BOT=${2:-"/mnt1boot"}
ROT=${3:-"/mnt2root"}
ONE="${BAK}/boot"
TWO="${BAK}/root"

test -d ${BOT} || exit 1
test -d ${ROT} || exit 1

test -d ${ONE} || exit 2
test -d ${TWO} || exit 2

RC=0

( cd ${ONE}; exec sudo rsync -av --delete-during . ${BOT} 1>&2 ) || RC=3

( cd ${TWO}; exec sudo rsync -av --delete-during . ${ROT} 1>&2 ) || RC=4

echo exit ${RC} 1>&2
exit ${RC}
