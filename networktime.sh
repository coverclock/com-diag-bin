#!/bin/bash
# Fetch some NTP info from the time server.
SERVER=${1:-"localhost"}
exec ntpq -c peer -c as -c rl ${SERVER}
