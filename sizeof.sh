#!/bin/bash
# Copyright 2022 Digital Aggregates Corporation, Arvada Colorado USA.
# https://github.com/coverclock/com-diag-hazer
# mailto:coverclock@diag.com
# Convenience script to run sizeof remotely via ssh.
ROOT=${HOME}/src/com-diag-diminuto/Diminuto
cd ${ROOT}
EXEC=out/host/bin
. ${EXEC}/setup
exec ${EXEC}/sizeof
