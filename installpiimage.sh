#!/bin/bash
# Copyright 2018 Digital Aggregates Corporation, Arvada CO USA.
IMG=${1:-"/dev/null"}
DEV=${2:-"/dev/null"}
BLK=${3:-"4M"}
CMD="dd bs=${BLK} if=${IMG} of=${DEV} conv=fsync"
echo "sudo ${CMD}" 1>&2
echo -n "[yN]? "
read YN
case "${YN}" in
[Yy]) ;;
*) exit 1;;
esac
exec sudo ${CMD}
