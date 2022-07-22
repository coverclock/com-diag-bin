#!/bin/bash
# Copyright 2019 Digital Aggregates Corporation, Arvada CO USA.
# USAGE pilocalbackup.sh [ BACKUPDIR ]
# EXAMPLE pilocalbackup.sh
# EXAMPLE pilocalbackup.sh /mnt/pi/hostname
# REFERENCES
# https://raspberrypi.stackexchange.com/questions/5427/can-a-raspberry-pi-be-used-to-create-a-backup-of-itself/28087#28087 .

NAM=$(basename $0 .sh)
SYS=$(hostname)
BAK=${1:-"/mnt/pi/${SYS}"}
TIM=$(date -u +%Y%m%dT%H%M%SZ)
ONE="${BAK}/"
TWO="${BAK}/root/"
DEV="${TWO}/dev"
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
/data/*
/dev/*
/media/*
/mnt/*
/proc/*
/run/*
/sys/*
/tmp/*
EOF

INC=""
INC="${INC} /dev/fd"
INC="${INC} /dev/full"
INC="${INC} /dev/null"
INC="${INC} /dev/ptmx"
INC="${INC} /dev/pts"
INC="${INC} /dev/random"
INC="${INC} /dev/shm"
INC="${INC} /dev/stderr"
INC="${INC} /dev/stdin"
INC="${INC} /dev/stdout"
INC="${INC} /dev/tty"
INC="${INC} /dev/urandom"
INC="${INC} /dev/zero"

RC=0

cp /dev/null ${LOG}
exec 2>>${LOG}
tail -f ${LOG} &
SAV=$!
trap "kill ${SAV}" HUP INT TERM EXIT

sudo rsync -axHv --delete-during                       ${BOT} ${ONE} 1>&2 || RC=3
sudo rsync -axHv --delete-during --exclude-from=${EXC} ${ROT} ${TWO} 1>&2 || RC=4
sudo rsync -axHv                                       ${INC} ${DEV} 1>&2 || RC=5

# This can take a long time, like tens of minutes. You
# can either take this flash write latency here, or when
# you unmount the backup device. I chose to embed it in
# the script, rather than leave the surprise for later.
sync
sync
sync

echo exit ${RC} 1>&2
exit ${RC}
