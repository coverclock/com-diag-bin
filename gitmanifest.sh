#!/bin/bash
# Copyright 2022 by the Digital Aggregates Corporation, Colorado, USA.
# Generates a list of files that have been modified in this git repo.
git status | grep '^[ 	]*modified:[ 	]*' | sed 's/^[ 	]*modified:[ 	]*//'
