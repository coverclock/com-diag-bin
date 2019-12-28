#!/bin/bash
# Copyright 2019 Digital Aggregates Corporation, Arvada CO USA.
# usage: piimagebackup.sh /dev/sdc /mnt/framistat.gz 4M
# N.B. If it works at all, it will only do so with the same SD card
# or perhaps one of the exact same size, brand, and model.
DEV=${1:-"/dev/null"}
ZIP=${2:-"/dev/null"}
BLK=${3:-"4M"}
CMD="sudo dd bs=${BLK} if=${DEV} | gzip > ${ZIP}"
test -f ${ZIP} && exit 2
test -b ${DEV} || exit 2
echo "${CMD}" 1>&2
echo -n "[yN]? "
read YN
case "${YN}" in
[Yy]) ;;
*) exit 1;;
esac
eval ${CMD}
