#!/bin/bash
# vi: set ts=4:
# Copyright 2016 by the Digital Aggregates Corporation, Colorado, USA.
# Licensed under the GPLv2.

function interruptible_sleep {
	local SLEEP=${1:-0}
	sleep ${SLEEP} &
	local PID=$!
	wait ${PID}
	kill ${PID} 2> /dev/null
}

function unjittered_sleep {
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
	interruptible_sleep ${MINIMUM}
}

function UNITTEST_1_interruptible_sleep {
	while true; do
		BEFORE=$(elapsedtime 1)
		interruptible_sleep 10
		AFTER=$(elapsedtime 1)
		echo $((${AFTER} - ${BEFORE}))
	done
}

function UNITTEST_2_unjittered_sleep {
	JITTER=1
	while true; do
		EPOCH=$(elapsedtime  1)
		date
		sleep ${JITTER}
		JITTER=$((4 - ${JITTER}))
		unjittered_sleep ${EPOCH} 5
	done
}
