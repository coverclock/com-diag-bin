#!/bin/bash
# Copyright 2019-2020 Digital Aggregates Corporation, Colorado, USA
# Licensed under the terms in LICENSE.txt
# Chip Overclock <coverclock@diag.com>
# https://github.com/coverclock/com-diag-diminuto
#
# ABSTRACT
#
# Continuously monitor the temperature sensor(s) on a Raspberry Pi using its
# vcgencmd tool.
#
# USAGE
#
# pitemp [ SECONDSDELAY ]
#
# EXAMPLE
#
# pitemp
#
# pitemp 10
#

PROGRAM=$(basename ${0})
HOSTNAME=$(hostname)
DELAY=${1:-"3"}
DEGREE=$'\u00B0'

while true; do
	TIMESTAMP=$(date -u +%Y-%m-%dT%H:%M:%S)
	TEMPERATURE=$(/opt/vc/bin/vcgencmd measure_temp | sed "s/'/${DEGREE}/; s/^.*=//")
	echo ${PROGRAM} ${TIMESTAMP}Z ${TEMPERATURE} ${HOSTNAME}
	sleep ${DELAY}
done
