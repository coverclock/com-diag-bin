#!/bin/bash
# Fetch some NTP info from the time server.
SERVER=${1:-"localhost"}
# \b	reject
# x	falsetick
# .	excess
# -	outlyer
# +	candidate
# #	selected (but not amongst top six)
# *	peer
# .	PPS peer
exec ntpq -c peer -c as -c rl ${SERVER}
