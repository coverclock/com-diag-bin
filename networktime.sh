#!/bin/bash
# Fetch some NTP info from the time server.
SERVER=${1:-"hourglass"}
exec ntpq -c peer -c as -c rl ${SERVER}
