#!/bin/bash
# vi: set ts=4:
# Copyright 2016 by the Digital Aggregates Corporation, Colorado, USA.
# Licensed under the GPLv2.

function com_diag_sleep_interruptible {
	local SLEEP=${1:-0}
	sleep ${SLEEP} &
	local PID=$!
	wait ${PID}
	kill ${PID} 2> /dev/null
}

function com_diag_sleep_unjittered {
	local THEN=${1}
	local SLEEP=${2:-0}
	local MINIMUM=${3:-1}
	local JITTER=0
	local NOW=$(elapsedtime 1)
	if [[ ${NOW} -gt ${THEN} ]]; then
		JITTER=$(( ${NOW} - ${THEN} ))
	fi
	if [[ ${JITTER} -lt ${SLEEP} ]]; then
		MINIMUM=$(( ${SLEEP} - ${JITTER} ))
	fi
	com_diag_sleep_interruptible ${MINIMUM}
}
