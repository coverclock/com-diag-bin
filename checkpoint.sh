#!/bin/sh

# amigo         - FreeRTOS on Arduino Mega 2560
# arduino       - Arduino Uno R3 musings
# arroyo        - SD-card based AT91RM9200-EK system
# assay         - INI file parser in C
# asterisk      - graphite:/etc/asterisk
# biscuit       - Self-installing hotpluggable software
# boodle        - Xilinx Zynq ZC702 ARM + FPGA noodlings
# buckaroo      - Java tools including Chip's Instant Managed Beans
# cascada       - Open Embedded and bitbake for the BeagleBoard
# chapparal     - Java ME buckaroo port
# cobbler       - Raspberry Pi musings
# concha        - Abstraction in C using Source and Sinks
# conestoga     - Android on Tablet
# contraption   - Android+GNU on BeagleBoard
# deringer      - Android application musings
# desperado     - C++ embedded design patterns
# desperadito   - Desperado Lite
# diablo        - C preprocessor-based state machine generator
# diminuto      - Linux/GNU systems programming library and toolkit
# hackamore     - Asterisk Management Interface (AMI) log analyzer
# hatband       - Python musings
# hayloft       - Amazon Web Services Simple Storage Service tools in C++
# harmony       - Instrumentation of Linux kernel random number generator
# horsefly      - AR.drone control on the BeagleBoard
# lariat        - Google Test (and now Google Mock) support
# luchador      - FreeRTOS on Arduino Due
# rustler       - Trace driven simulations based on Saleae Logic captures
# scala         - Scala musings
# solidfire     - SolidFire musings
# telegraph     - C-based functions that are not Linux or GNU specific

SVNR="\
Amigo \
Assay \
Biscuit \
Boodle \
Buckaroo \
Cascada \
Chapparal \
Cobbler \
Concha \
Conestoga \
Contraption \
Deringer \
Desperadito \
Desperado \
Diablo \
Diminuto \
Hackamore \
Harmony \
Hatband \
Hayloft \
Horsefly \
Lariat \
Luchador \
Rustler \
Telegraph \
"

GHUB="\
Amigo \
Biscuit \
Buckaroo \
Concha \
Desperadito \
Diminuto \
Hackamore \
Hayloft \
Lariat \
Telegraph \
"

for PROJ in ${GHUB}; do

    ( make -C ${PROJ} -f ${PROJ}/Makefile dcommit )

done
