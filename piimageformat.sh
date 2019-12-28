#!/bin/bash
# Copyright 2019 Digital Aggregates Corporation, Arvada CO USA.
# usage: piimageformat.sh /dev/sdc
# N.B. If it works at all, it will only do so with the same SD card
# or perhaps one of the exact same size, brand, and model.

DEV=${1:-"/dev/null"}
BOT="${DEV}1"
ROT="${DEV}2"

test -b ${DEV} || exit 1
mount | grep "${DEV}" && exit 1

# The sleep is necessary because (I think) the kernel driver
# decides to make the device busy for a moment once we change
# the partitioning, so the write (w) sees the device busy.
(
	echo 'o'
	echo 'n'
	echo 'p'
	echo '1'
	echo '8192'
	echo '+64M'
	echo 'n'
	echo 'p'
	echo '2'
	echo '139264'
	echo ''
	echo 't'
	echo '1'
	echo 'c'
	sleep 5
	echo 'w'
) | sudo fdisk ${DEV} || exit 2

sudo fdisk -l ${DEV} || exit 3

sudo mkfs.fat  -F32 ${BOT} || exit 4

sudo mkfs.ext4      ${ROT} || exit 5

exit 0
