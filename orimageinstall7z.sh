#!/bin/bash
# Copyright 2023 Digital Aggregates Corporation, Arvada CO USA.
# Installs a 7z compressed image file for an Orange Pi.
# (The Orange Pi is a competitor to the Raspberry Pi that uses a
# Rockchip 8-core 64-bit CPU. This script uses the Orange Pi image
# files that come compressed using the 7z algorithm which is supposed
# to have a higher compression ratio than others. According to the man
# page, the compressed file must end in the 7z suffix.)
# USAGE orimageinsgall7z.sh 7ZFILE DEVICE [ BLOCKSIZE ]
# EXAMPLE orimaginstall7z.sh orangepi.7z /dev/sdb
XZF=${1:-"/dev/null"}
DEV=${2:-"/dev/null"}
BLK=${3:-"4M"}
SRC=$(readlink -e ${XZF})
SNK=$(readlink -e ${DEV})
CMD="p7zip -d -c ${SRC} | sudo dd bs=${BLK} of=${SNK} conv=fsync"
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
