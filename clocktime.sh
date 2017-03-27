#!/bin/bash
# Extract the local clock time from the NTP server host.
SERVER=${1:-"localhost"}
REFTIME=$(ntpq -c "rv 0 clock" ${SERVER})
STRTIME=$(echo ${REFTIME} | awk '/clock=/ { sub(/,/,"",$6); print $2,$3,$4,$5,$6; }')
ISOTIME=$(date -d "${STRTIME}" +"%Y-%m-%d %H:%M:%S.%N %Z")
DSPTIME="${ISOTIME:0:23} ${ISOTIME:30}"
echo ${DSPTIME}

