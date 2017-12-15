#!/bin/bash
# Usage:     changed.sh DIRECTORY [ DIRECTORY ... ]
# Example:   changed.sh ~/src/resource-manager ~/src/safety-services ~/src/user-services
# Abstract:  Generate a manifest of files that have been changed relative to the base.
# Assumes:   All git repositories in each directory root are checked out on the same branch (e.g. resource-manager).
# Status:    EXPERIMENTAL
# Author:    jsloan@diag.com

for ROOT in $*; do
	(
		cd $ROOT
		BRANCH="$(repo status | head -1 | awk '{ print $4; }')"
		repo forall -p -c git diff --name-only origin/$BRANCH |
			awk '/^$/ { next; } /^project / { project=$2; next; } { print root"/"project$0; next; }' root="${ROOT}"
	)
done
