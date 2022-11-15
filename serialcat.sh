#!/bin/bash
# Copyright 2022 Digital Aggregates Corporation, Arvada Colorado USA.
# https://github.com/coverclock/com-diag-hazer
# mailto:coverclock@diag.com
# Test script to use socat on serial-ish port (mostly for strace(1)).
DEVICE=${1:-"/dev/ttyUSB0"}
RATE=${2:-"115200"}
socat OPEN:${DEVICE},b${RATE},cs8,rawer -
