#!/bin/bash
# Copyright 2019 Digital Aggregates Corporation, Arvada CO USA.
# usage: backuppiimage.sh /dev/sdc /mnt/framistat.zip
DEV=${1:-"/dev/null"}
ZIP=${2:-"/dev/null"}
CMD="sudo dd if=${DEV} | zip ${ZIP} -"
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
