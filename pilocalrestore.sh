#!/bin/bash
# Copyright 2019 Digital Aggregates Corporation, Arvada CO USA.
# USAGE pilocalrestore.sh BACKUPDIR BOOTDIR ROOTDIR
# EXAMPLE pilocalrestore.sh /mnt/pi/hostname /mntboot /mntroot
# REFERENCES
# https://raspberrypi.stackexchange.com/questions/5427/can-a-raspberry-pi-be-used-to-create-a-backup-of-itself/28087#28087

NAM=$(basename $0 .sh)
BAK=${1:-"/mnt/pi/localhost"}
BOT=${2:-"/mnt1boot"}
ROT=${3:-"/mnt2root"}
ONE="${BAK}/boot/"
TWO="${BAK}/root/"

test -d ${BOT} || exit 1
test -d ${ROT} || exit 1

test -d ${ONE} || exit 2
test -d ${TWO} || exit 2

RC=0

sudo rsync -aHv ${ONE} ${BOT} 1>&2 || RC=3
sudo rsync -aHv ${TWO} ${ROT} 1>&2 || RC=4

echo "N.B. ${EDITOR:-"edit"} ${BOT}/cmdline.txt to change boot partition." 1>&2
echo "N.B. ${EDITOR:-"edit"} ${ROT}/etc/dhcpcd.conf to change static IP address." 1>&2
echo "N.B. ${EDITOR:-"edit"} ${ROT}/etc/hostname to change host name." 1>&2
echo "N.B. ${EDITOR:-"edit"} ${ROT}/etc/hosts to change host name resolution." 1>&2
echo "N.B. Perform a file system check!" 1>&2

# THis can take a long time, like tens of minutes. You
# can either take this flash write latency here, or when
# you unmount the root file system (the boot file system
# writes relatively quickly). I chose to embed it in
# the script, rather than leave the surprise for later.
sync
sync
sync

echo exit ${RC} 1>&2
exit ${RC}
