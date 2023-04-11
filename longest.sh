#!/bin/bash
# Copyright 2023 by the Digital Aggregates Corporation, Colorado, USA.
# Licensed under the GPLv2.
awk -- 'BEGIN { M=0; } { L=length($0); if (L>M) M=L; } END { print M; }'
