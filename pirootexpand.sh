#!/bin/bash
# Copyright 2019 Digital Aggregates Corporation, Arvada CO USA.
# USAGE pirootexpand.sh PARTITION 
# EXAMPLE pirootexpand.sh /dev/sdb2
ROT=${1:-"/dev/null"}
test -b ${DEV} || exit 1
sudo e2fsck -f ${ROT} || exit 2
sudo resize2fs ${ROT} || exit 3
