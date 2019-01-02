#!/bin/bash
# Copyright 2018 Digital Aggregates Corporation, Arvada CO USA.
# usage: installpiimage.sh rpi3.img /dev/sdb 1M
IMG=${1:-"/dev/null"}
DEV=${2:-"/dev/null"}
BLK=${3:-"4M"}
CMD="dd bs=${BLK} if=${IMG} of=${DEV} conv=fsync"
test -f ${IMG} || exit 2
test -b ${DEV} || exit 2
echo "sudo ${CMD}" 1>&2
echo -n "[yN]? "
read YN
case "${YN}" in
[Yy]) ;;
*) exit 1;;
esac
exec sudo ${CMD}
