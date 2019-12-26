#!/bin/bash
# Copyright 2019 Digital Aggregates Corporation, Arvada CO USA.
# usage: backuppilocal.sh [ /mnt/pi/hostname ]
# Based on goldilocks via https://raspberrypi.stackexchange.com/questions/5427/can-a-raspberry-pi-be-used-to-create-a-backup-of-itself/28087#28087 .

NAM=$(basename $0 .sh)
SYS=$(hostname)
BAK=${1:-"/mnt/pi/${SYS}"}
TIM=$(date -u +%Y%m%dT%H%M%SZ)
ONE="${BAK}/boot"
TWO="${BAK}/root"
LOG="${BAK}/${TIM}.log"
ROT="/"
BOT="/boot"

test -d ${ROT} || exit 2
test -d ${BOT} || exit 2

sudo mkdir -p ${ONE} || exit 2
sudo mkdir -p ${TWO} || exit 2

EXC=$(mktemp ${TMPDIR:="/tmp"}/${NAM}-${SYS}.exc.XXXXXXXXXX)
trap "rm -f ${EXC}" HUP INT TERM EXIT
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

ERR=$(mktemp ${TMPDIR:="/tmp"}/${NAM}-${SYS}.err.XXXXXXXXXX)
cp /dev/null ${ERR}
exec 2>>${ERR}

RC=0

sudo rsync -aHv --delete --one-file-system ${BOT} ${ONE} || RC=3
sudo rsync -aHv --delete --one-file-system --exclude-from=${EXC} ${ROT} ${TWO} || RC=4
sudo mv -i ${ERR} ${LOG} || RC=5
cat ${LOG}
echo exit ${RC}

exit ${RC}
