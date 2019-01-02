#!/bin/sh
# Copyright 2018 Digital Aggregates Corporation, Arvada Colorado USA.
# https://github.com/coverclock/com-diag-vamoose
# mailto:coverclock@diag.com

PKG=${1:-"harness"}
export GOPATH="${HOME}/go"
cd ${GOPATH}/src
go build github.com/coverclock/com-diag-vamoose/Vamoose/cmd/fletch
go build github.com/coverclock/com-diag-vamoose/Vamoose/cmd/shape
dd if=/dev/urandom count=1000 | ./fletch -V -b 512 | ./shape -V -p 2048 -s 1024 -b 512 | ./fletch -V -b 512 > /dev/null
