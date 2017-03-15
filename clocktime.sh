#!/bin/bash
# Extract the local clock time from the NTP server host.
SERVER=${1:-"hourglass"}
REFTIME=$(ntpq -c "rv 0 clock" ${SERVER})
# clock=dc73db64.0e3e1f16  Wed, Mar 15 2017  9:25:24.055
STRTIME=${REFTIME#clock=* }
ISOTIME=$(date -d "${STRTIME}" +"%Y-%m-%d %H:%M:%S.%N %Z")
# 2017-03-15 09:33:56.055000000 MDT
DSPTIME="${ISOTIME:0:23} ${ISOTIME:30}"
echo ${DSPTIME}
