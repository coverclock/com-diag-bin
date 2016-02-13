#!/bin/bash
# vi: set ts=4:
# Copyright 2016 by the Digital Aggregates Corporation, Colorado, USA.
# Licensed under the GPLv2.

function interruptible_sleep {
	local DELAY=${1:-0}
	sleep ${DELAY} &
	local PID=$!
	wait ${PID}
	kill ${PID} 2> /dev/null
}

function unjittered_sleep {
	local THEN=${1}
	local DELAY=${2:-0}
	local MINIMUM=${3:-1}
	local JITTER=0
	local NOW=$(elapsedtime 1)
	if [[ ${NOW} -gt ${THEN} ]]; then
		JITTER=$(( ${NOW} - ${THEN} ))
	fi
	if [[ ${JITTER} -lt ${DELAY} ]]; then
		MINIMUM=$(( ${DELAY} - ${JITTER} ))
	fi
	interruptible_sleep ${MINIMUM}
}
