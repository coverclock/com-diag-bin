#!/bin/bash
# Copyright 2023 Digital Aggregates Corporation, Arvada CO USA.
# USAGE v5imageinstallbz.sh BZ2FILE DEVICE [ BLOCKSIZE ]
# EXAMPLE v5imageinstallbz.sh starfive-jh7110-VF2_515_v2.5.0-69.img.bz2 /dev/sdc
BZ2=${1:-"/dev/null"}
DEV=${2:-"/dev/null"}
BLK=${3:-"4M"}
SRC=$(readlink -e ${BZ2})
SNK=$(readlink -e ${DEV})
CMD="bunzip2 -c ${SRC} | sudo dd bs=${BLK} of=${SNK} conv=fsync"
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
