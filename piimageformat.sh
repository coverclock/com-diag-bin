#!/bin/bash
# Copyright 2019 Digital Aggregates Corporation, Arvada CO USA.
# USAGE piimageformat.sh DEVICE [ RELEASE | PART1ENDSECTOR PART2BEGINSECTOR ]
# EXAMPLE piimageformat.sh /dev/sdc buster
# REFERENCES
# https://raspberrypi.stackexchange.com/questions/29947/reverse-the-expand-root-fs/29952#29952
# https://github.com/RPi-Distro/pi-gen/blob/master/export-noobs/00-release/files/partitions.json
# https://ubuntu.com/tutorials/how-to-install-ubuntu-on-your-raspberry-pi

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
elif [[ "${END}" == "focal" ]]; then
	END=526335
	BEG=526336
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
	echo 'o'
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
	echo 't'
	echo '1'
	echo 'c'
	echo 't'
	echo '2'
	echo '83'
	echo 'p'
	sleep 5
	echo 'w'
) | sudo fdisk ${DEV} || exit 2

sudo fdisk -l ${DEV} || exit 3

yes | sudo mkfs.fat  -F32            ${BOT} || exit 4
yes | sudo mkfs.ext4 -O '^huge_file' ${ROT} || exit 4

sudo fatlabel ${BOT} BOOT || exit 5
sudo e2label  ${ROT} ROOT || exit 5

sudo blkid ${BOT} || exit 6
sudo blkid ${ROT} || exit 6

sudo fsck.fat  -y    ${BOT} || exit 7
sudo fsck.ext4 -y -f ${ROT} || exit 7

sync
sync
sync

exit 0
