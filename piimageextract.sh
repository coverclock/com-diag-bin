#!/bin/bash
# Copyright 2018 Digital Aggregates Corporation, Arvada CO USA.
# usage: piimageextract.sh /dev/sdc ./framistat.bin 1M
DEV=${1:-"/dev/null"}
IMG=${2:-"/dev/null"}
BLK=${3:-"4M"}
CMD="dd bs=${BLK} if=${DEV} of=${IMG}"
test -f ${IMG} && exit 2
test -b ${DEV} || exit 2
echo "sudo ${CMD}" 1>&2
echo -n "[yN]? "
read YN
case "${YN}" in
[Yy]) ;;
*) exit 1;;
esac
exec sudo ${CMD}
