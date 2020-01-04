#!/bin/bash
# Copyright 2019 Digital Aggregates Corporation, Arvada CO USA.
# USAGE piimageexpand.sh DEVICE [ RELEASE | PART1ENDSECTOR PART2BEGINSECTOR ]
# EXAMPLE piimageexpand.sh /dev/sdc buster
# EXAMPLE piimageexpand.sh /dev/sdc 532479 532480
# REFERENCES
# https://raspberrypi.stackexchange.com/questions/29947/reverse-the-expand-root-fs/29952#29952
# https://github.com/RPi-Distro/pi-gen/blob/master/export-noobs/00-release/files/partitions.json

DEV=${1:-"/dev/null"}
END=${2:-""}
BEG=${3:-""}

if [[ "${END}" == "jessie" ]]; then
	END=93596
	BEG=94208
elif [[ "${END}" == "stretch" ]]; then
	END=96042
	BEG=98304
elif [[ "${END}" == "buster" ]]; then
	END=532479
	BEG=532480
else
	:
fi

test -b ${DEV} || exit 1
mount | grep "${DEV}" && exit 1
test -n "${END}" || exit 1
test -n "${BEG}" || exit 1

BOT="${DEV}1"
ROT="${DEV}2"

# The sleep is necessary because (I think) the kernel driver
# makes the device busy for a moment once we change the
# partitioning (even though we haven't written yet), so the
# write (w) sees the device as unavailable.
(
	echo 'd'
	echo '2'
	echo 'd'
	echo 'n'
	echo 'p'
	echo '1'
	echo '8192'
	echo "${END}"
	echo 'n'
	echo 'p'
	echo '2'
	echo "${BEG}"
	echo ''
	echo 'p'
	sleep 5
	echo 'w'
) | sudo fdisk ${DEV} || exit 2

sudo fdisk -l ${DEV} || exit 3

sudo fsck.fat  -y    ${BOT} || exit 4
sudo fsck.ext4 -y -f ${ROT} || exit 4

sudo blkid ${BOT} || exit 5
sudo blkid ${ROT} || exit 5

sudo resize2fs ${ROT} || exit 6

sudo fsck.ext4 -y -f ${ROT} || exit 7

sync
sync
sync

exit 0
