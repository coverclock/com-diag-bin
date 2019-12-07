#!/bin/bash
export GTK_MODULES=gail:atk-bridge:unity-gtk-module 
export GNOME_DESKTOP_SESSION_ID=this-is-deprecated 
# --traditional
octave $*
