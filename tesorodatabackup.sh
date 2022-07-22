#!/bin/bash
# Copyright 2021 Digital Aggregates Corporation, Arvada CO USA.
# USAGE tesorodtabackup.sh [ FROMDIR [ TODIR ] ]

NAM=$(basename $0 .sh)
SRC=${1:-"/mnt1"}
SNK=${2:-"/mnt2"}
TIM=$(date -u +%Y%m%dT%H%M%SZ)
LOG="./${NAM}-${TIM}.log"

test -d ${SRC} || exit 1
test -d ${SNK} || exit 2

RC=0

cp /dev/null ${LOG}
exec 2>>${LOG}
tail -f ${LOG} &
SAV=$!
trap "kill ${SAV}" HUP INT TERM EXIT

sudo rsync -axHv --delete-during ${SRC} ${SNK} 1>&2 || RC=3

# This can take a long time, like tens of minutes. You
# can either take this flash write latency here, or when
# you unmount the backup device. I chose to embed it in
# the script, rather than leave the surprise for later.
sync
sync
sync

echo exit ${RC} 1>&2
exit ${RC}
