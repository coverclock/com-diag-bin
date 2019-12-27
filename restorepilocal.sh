#!/bin/bash
# Copyright 2019 Digital Aggregates Corporation, Arvada CO USA.
# usage: restorepilocal.sh [ /mnt/pi/hostname [ /mnt2/ [ /mnt3/boot ] ] ]
# Based on goldilocks via https://raspberrypi.stackexchange.com/questions/5427/can-a-raspberry-pi-be-used-to-create-a-backup-of-itself/28087#28087 .

NAM=$(basename $0 .sh)
BAK=${1:-"/mnt/pi/localhost"}
ROT=${2:-""}
BOT=${3:-""}
ONE="${BAK}/root"
TWO="${BAK}/boot"

test -d ${ONE} || exit 2
test -d ${TWO} || exit 2

RC=0

if [[ -n "${ROT}" ]]; then
    sudo rsync -av --delete-during ${ONE} ${ROT} 1>&2 || RC=3
fi

if [[ -n "${BOT}" ]]; then
    sudo rsync -av --delete-during ${TWO} ${BOT} 1>&2 || RC=4
fi

echo exit ${RC} 1>&2
exit ${RC}
