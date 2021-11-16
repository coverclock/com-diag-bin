#!/bin/bash
# Copyright 2018-2020 Digital Aggregates Corporation, Arvada CO USA.
# USAGE piimageinstall.sh ZIPFILE DEVICE [ BLOCKSIZE ]
# EXAMPLE piimageinstall.sh rpi3.zip /dev/sdb
ZIP=${1:-"/dev/null"}
DEV=${2:-"/dev/null"}
BLK=${3:-"4M"}
SRC=$(readlink -e ${ZIP})
SNK=$(readlink -e ${DEV})
CMD="unzip -p ${SRC} | sudo dd bs=${BLK} of=${SNK} conv=fsync"
test -f ${SRC} || exit 2
test -b ${SNK} || exit 2
echo "${CMD}" 1>&2
echo -n "[yN]? "
read YN
case "${YN}" in
[Yy]) ;;
*) exit 1;;
esac
eval ${CMD}
