#!/bin/bash
# vi: set ts=4:
# Copyright 2016 by the Digital Aggregates Corporation, Colorado, USA.
# Licensed under the GPLv2.

if [[ -x ${HOME}/src/Diminuto/Diminuto/out/host/bin/setup ]]; then
	. ${HOME}/src/Diminuto/Diminuto/out/host/bin/setup
	which elapsedtime
fi

. $(dirname $(basename $0))/functions_sleep.sh

################################################################################

function UNITTEST_0_com_diag_sleep_interruptible {
	for II in 0 1 2 3 4 55 6 7 8 9; do
		BEFORE=$(elapsedtime 1)
		com_diag_sleep_interruptible 10
		AFTER=$(elapsedtime 1)
		echo $((${AFTER} - ${BEFORE}))
	done
}

echo UNITTEST_0_com_diag_sleep_interruptible
UNITTEST_0_com_diag_sleep_interruptible;

################################################################################

function UNITTEST_1_com_diag_sleep_unjittered {
	JITTER=1
	for II in 0 1 2 3 4 55 6 7 8 9; do
		EPOCH=$(elapsedtime  1)
		date
		sleep ${JITTER}
		JITTER=$((4 - ${JITTER}))
		com_diag_sleep_unjittered ${EPOCH} 5
	done
}

echo UNITTEST_1_com_diag_sleep_unjittered
UNITTEST_1_com_diag_sleep_unjittered

################################################################################
