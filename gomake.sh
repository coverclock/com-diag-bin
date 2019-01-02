#!/bin/sh
# Copyright 2018 Digital Aggregates Corporation, Arvada Colorado USA.
# https://github.com/coverclock/com-diag-vamoose
# mailto:coverclock@diag.com

export GOPATH="${HOME}/go"
mkdir -p ${HOME}/src
cd ${HOME}/src
git clone https://github.com/coverclock/com-diag-vamoose
mkdir -p ${GOPATH}/bin ${GOPATH}/pkg ${GOPATH}/src/github.com/coverclock
cd ${GOPATH}/src/github.com/coverclock
ln -f -s ${HOME}/src/com-diag-vamoose
