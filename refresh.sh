#!/bin/bash
PROJ=${1:-"Hazer"}
REPO=$(echo ${PROJ} | tr '[A-Z]' '[a-z]')
make -C ${HOME}/src/com-diag-diminuto/Diminuto refresh && make -C ${HOME}/src/com-diag-${REPO}/${PROJ} refresh
