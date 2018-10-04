#!/bin/sh
# Copyright 2018 Digital Aggregates Corporation, Arvada Colorado USA.
# https://github.com/coverclock/com-diag-vamoose
# mailto:coverclock@diag.com

PKG=${1:-"harness"}
export GOPATH="${HOME}/go"
cd ${GOPATH}/src
vim github.com/coverclock/com-diag-vamoose/Vamoose/pkg/${PKG}
