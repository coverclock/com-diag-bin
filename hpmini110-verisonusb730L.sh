#!/bin/bash
# Copyright 2020 by the Digital Aggregates Corporation, Colorado, USA.
# Author: coverclock@diag.com
# EXPERIMENTAL
sudo rmmod rndis_host
sudo usb_modeswitch -v 0x1410 -p 0x9030 -u 2
