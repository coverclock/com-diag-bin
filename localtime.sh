#!/bin/bash
# Display the local time.
ISOTIME=$(date +"%Y-%m-%d %H:%M:%S.%N %Z")
# 2017-03-15 09:33:56.055000000 MDT
DSPTIME="${ISOTIME:0:23} ${ISOTIME:30}"
echo ${DSPTIME}
