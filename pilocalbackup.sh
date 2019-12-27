#!/bin/bash
# Copyright 2019 Digital Aggregates Corporation, Arvada CO USA.
# usage: backuppilocal.sh [ /mnt/pi/hostname ]
# Based on goldilocks via https://raspberrypi.stackexchange.com/questions/5427/can-a-raspberry-pi-be-used-to-create-a-backup-of-itself/28087#28087 .

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

test -d ${ROT} || exit 2
test -d ${BOT} || exit 2

mkdir -p ${ONE} || exit 2
mkdir -p ${TWO} || exit 2

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

sudo rsync -aHv --delete --one-file-system                       ${BOT} ${ONE} | tee -a ${LOG} 1>&2 || RC=3
sudo rsync -aHv --delete --one-file-system --exclude-from=${EXC} ${ROT} ${TWO} | tee -a ${LOG} 1>&2 || RC=4

echo exit ${RC} 1>&2
exit ${RC}
