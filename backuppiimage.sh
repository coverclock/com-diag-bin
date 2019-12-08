#!/bin/bash
# Copyright 2019 Digital Aggregates Corporation, Arvada CO USA.
# usage: backuppiimage.sh /dev/sdc /mnt/framistat.zip 4M
# N.B.: Decompressing the zipped image consistently throws an
# "invalid compressed data--length error" message seemingly no
# matter what I try. But the resulting decompressed file diffs
# just fine against the original image.
DEV=${1:-"/dev/null"}
ZIP=${2:-"/dev/null"}
BLK=${3:-"4M"}
TMP=$(mktemp ${TMPDIR:="/tmp"}/$(basename $0).XXXXXXXXXX)
trap "rm -f ${TMP}" HUP INT TERM EXIT
CMD="dd bs=${BLK} if=${DEV} of=${TMP} && zip ${ZIP} ${TMP}"
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
