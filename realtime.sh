#!/bin/bash
# Extract the time from the real-time hardware clock. 
SERVER=${1:-"localhost"}
if [[ "${SERVER}" == "localhost" ]]; then
	HRDTIME=$(sudo /sbin/hwclock -u -r)
elif [[ "${SERVER}" == "$(hostname)" ]]; then
	HRDTIME=$(sudo /sbin/hwclock -u -r)
else
	HRDTIME=$(ssh ${SERVER} sudo /sbin/hwclock -u -r)
fi
# Sun 19 Mar 2017 02:39:37 PM MDT  -0.891855 seconds
FLDTIME=${HRDTIME//:/ }
# Sun 19 Mar 2017 02 39 37 PM MDT  -0.891855 seconds
set ${FLDTIME}
HH=${5}
if [[ "${8}" == "PM" ]]; then
	HH=$((${HH} + 12))
fi
STRTIME="${1} ${3} ${2} ${HH}:${6}:${7} ${9} ${4}"
ISOTIME=$(date -d "${STRTIME}" +"%Y-%m-%d %H:%M:%S.%N %Z")
# 2017-03-15 09:33:56.055000000 MDT
DSPTIME="${ISOTIME:0:23} ${ISOTIME:30}"
echo ${DSPTIME}
