#!/bin/bash
# Copyright 2018-2020 Digital Aggregates Corporation, Arvada CO USA.
# USAGE piimageextract.sh DEVICE ZIPFILE [ BLOCKSIZE ]
# EXAMPLE piimageextract.sh /dev/sdc rpi3.zip
DEV=${1:-"/dev/null"}
ZIP=${2:-"/dev/null"}
BLK=${3:-"4M"}
CMD="sudo dd bs=${BLK} if=${DEV} | zip ${ZIP} -"
test -f ${ZIP} && exit 2
test -b ${DEV} || exit 2
echo "sudo ${CMD}" 1>&2
echo -n "[yN]? "
read YN
case "${YN}" in
[Yy]) ;;
*) exit 1;;
esac
eval ${CMD}
