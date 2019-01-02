#!/bin/bash
NOW=$(date +"%Y%m%d%H%M")
cd "/Users/jsloan/Documents/Virtual Machines.localized"
zip -r /Volumes/13034895178/Windows_8_x64_${NOW}.zip "Windows 8 x64.vmwarevm"
