#!/bin/bash
for DD in ${HOME}/src/com-diag-* ${HOME}/src/com-cranequin-* ${HOME}/src/edu-wright-*; do
	( cd ${DD}; pwd; git pull )
done
