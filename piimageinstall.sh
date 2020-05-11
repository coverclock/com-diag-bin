#!/bin/bash
# Copyright 2018-2020 Digital Aggregates Corporation, Arvada CO USA.
# USAGE piimageinstall.sh ZIPFILE DEVICE [ BLOCKSIZE ]
# EXAMPLE piimageinstall.sh rpi3.zip /dev/sdb
ZIP=${1:-"/dev/null"}
DEV=${2:-"/dev/null"}
BLK=${3:-"4M"}
CMD="unzip -p ${ZIP} | sudo dd bs=${BLK} of=${DEV} conv=fsync"
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
