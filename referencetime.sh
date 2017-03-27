#!/bin/bash
# Extract the NTP reference time - when the clock was last updated -from the NTP server.
SERVER=${1:-"localhost"}
REFTIME=$(ntpq -c "rv 0 reftime" ${SERVER})
STRTIME=$(echo ${REFTIME} | awk '/reftime=/ { sub(/,/,"",$6); print $2,$3,$4,$5,$6; }')
ISOTIME=$(date -d "${STRTIME}" +"%Y-%m-%d %H:%M:%S.%N %Z")
DSPTIME="${ISOTIME:0:23} ${ISOTIME:30}"
echo ${DSPTIME}
