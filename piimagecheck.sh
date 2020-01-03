#!/bin/bash
# Copyright 2019 Digital Aggregates Corporation, Arvada CO USA.
# USAGE piimagecheck.sh DEVICE [ BOOTPART [ ROOTPART ] ]
# EXAMPLE piimageexpand.sh /dev/sdb
# EXAMPLE piimageexpand.sh /dev/sdb /dev/sdb1 /dev/sdb7

DEV=${1:-"/dev/null"}
BOT=${2:-"${DEV}1"}
ROT=${3:-"${DEV}2"}

test -b ${DEV} || exit 1
test -b ${BOT} || exit 1
test -b ${ROT} || exit 1

mount | grep "${BOT}" && exit 1
mount | grep "${ROT}" && exit 1

sudo fdisk -l ${DEV} || exit 2

sudo fsck.fat  -y    ${BOT} || exit 3
sudo fsck.ext4 -y -f ${ROT} || exit 3

sync
sync
sync

exit 0
