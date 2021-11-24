#!/bin/bash
# Copyright 2021 Digital Aggregates Corporation, Arvada CO USA.
# USAGE piubuntuinstall.sh XZFILE DEVICE [ BLOCKSIZE ]
# EXAMPLE piubuntuinstall.sh ubuntu.xz /dev/sdb
FIL=${1:-"/dev/null"}
DEV=${2:-"/dev/null"}
BLK=${3:-"4M"}
SRC=$(readlink -e ${FIL})
SNK=$(readlink -e ${DEV})
CMD="xzcat ${SRC} | sudo dd bs=${BLK} of=${SNK} conv=fsync"
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
sync
sync
sync
