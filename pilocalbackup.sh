#!/bin/bash
# Copyright 2019 Digital Aggregates Corporation, Arvada CO USA.
# usage: pilocalbackup.sh [ /mnt/pi/hostname ]

# Based on 
# https://raspberrypi.stackexchange.com/questions/5427/can-a-raspberry-pi-be-used-to-create-a-backup-of-itself/28087#28087 .
# by user goldilocks.

NAM=$(basename $0 .sh)
SYS=$(hostname)
BAK=${1:-"/mnt/pi/${SYS}"}
TIM=$(date -u +%Y%m%dT%H%M%SZ)
ONE="${BAK}/"
TWO="${BAK}/root/"
ROT="/"
BOT="/boot"
EXC="${BAK}/${NAM}-${TIM}.exc"
LOG="${BAK}/${NAM}-${TIM}.log"

mkdir -p ${ONE} || exit 1
mkdir -p ${TWO} || exit 1

test -d ${ROT} || exit 2
test -d ${BOT} || exit 2

cat << EOF > ${EXC}
/boot/*
/dev/*
/media/*
/mnt/*
/proc/*
/run/*
/sys/*
/tmp/*
EOF

cp /dev/null ${LOG}

RC=0

sudo rsync -axHv --delete                       ${BOT} ${ONE} | tee -a ${LOG} 1>&2 || RC=3
sudo rsync -axHv --delete --exclude-from=${EXC} ${ROT} ${TWO} | tee -a ${LOG} 1>&2 || RC=4

echo exit ${RC} 1>&2
exit ${RC}
