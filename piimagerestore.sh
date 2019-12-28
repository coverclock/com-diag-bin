#!/bin/bash
# Copyright 2019 Digital Aggregates Corporation, Arvada CO USA.
# usage: piimagerestore.sh /mnt/framistat.gz /dev/sdc 4M
# N.B. If it works at all, it will only do so with the same SD card
# or perhaps one of the exact same size, brand, and model.
ZIP=${1:-"/dev/null"}
DEV=${2:-"/dev/null"}
BLK=${3:-"4M"}
CMD="gunzip --stdout ${ZIP} | sudo dd bs=${BLK} of=${DEV} conv=fsync"
test -f ${ZIP} || exit 2
test -b ${DEV} || exit 2
echo "${CMD}" 1>&2
echo -n "[yN]? "
read YN
case "${YN}" in
[Yy]) ;;
*) exit 1;;
esac
eval ${CMD}
