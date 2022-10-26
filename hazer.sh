#!/bin/bash
# Copyright 2022 Digital Aggregates Corporation, Arvada Colorado USA.
# https://github.com/coverclock/com-diag-hazer
# mailto:coverclock@diag.com
# Convenience script to monitor instance of gpstool running headless.
FILE=${1:-"rover"}
TYPE=${2:-"out"}
cd ${HOME}/src/com-diag-hazer/Hazer
. out/host/bin/setup
peruse ${FILE} ${TYPE}