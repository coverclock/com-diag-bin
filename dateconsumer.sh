#!/bin/bash
# Copyright 2017 Digital Aggregates Corporation, Arvada Colorado USA.
# Set date using date provided by remote host. Typically requires root.
USERATHOST=${1-"jsloan@mercury"}
date -u $(ssh ${USERATHOST} dateprovider)
