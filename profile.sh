:
# Copyright 2014 by the Digital Aggregates Corporation, Colorado, USA.
# Licensed under the GPLv2.

NEWPATH="$HOME/bin"
echo $PATH | grep -q "$NEWPATH" || export PATH=$NEWPATH:$PATH

#NEWPATH="/opt/CodeSourcery/Sourcery_CodeBench_Lite_for_ARM_EABI/bin"
#echo $PATH | grep -q "$NEWPATH" || export PATH=$PATH:$NEWPATH

#NEWPATH="$HOME/projects/cobbler/tools-master/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin"
#echo $PATH | grep -q "$NEWPATH" || export PATH=$PATH:$NEWPATH

#NEWPATH="/usr/local/cuda-6.0/bin"
#echo $PATH | grep -q "$NEWPATH" || export PATH=$NEWPATH:$PATH

#NEWPATH="/usr/local/cuda-6.0/lib"
#echo $LD_LIBRARY_PATH | grep -q "$NEWPATH" || export LD_LIBRARY_PATH=$NEWPATH:$LD_LIBRARY_PATH

#NEWPATH="$HOME/Projects/stampede/dtc"
#echo $PATH | grep -q "$NEWPATH" || export PATH=$NEWPATH:$PATH

#NEWPATH="$HOME/Projects/stampede/u-boot/tools"
#echo $PATH | grep -q "$NEWPATH" || export PATH=$NEWPATH:$PATH

JAVA_ROOT="$HOME/Applications/jdk1.7.0_67"
export JAVA_HOME="$JAVA_ROOT/jre"
NEWPATH="$JAVA_ROOT/bin"
echo $PATH | grep -q "$NEWPATH" || export PATH=$NEWPATH:$PATH

#CYANOGENMOD_ROOT="${HOME}/Projects/corset/cm-10.2"
#NEWPATH="${CYANOGENMOD_ROOT}/prebuilts/gcc/linux-x86/arm/arm-linux-androideabi-4.7/bin"
#echo $PATH | grep -q "$NEWPATH" || export PATH=$NEWPATH:$PATH
#NEWPATH="${CYANOGENMOD_ROOT}/prebuilts/gcc/linux-x86/arm/arm-eabi-4.7/bin"
#echo $PATH | grep -q "$NEWPATH" || export PATH=$NEWPATH:$PATH

#BUILDROOT_ROOT="${HOME}/Projects/dumpling/buildroot-2014.08/output"
#NEWPATH="${BUILDROOT_ROOT}/host/usr/bin"
#echo $PATH | grep -q "$NEWPATH" || export PATH=$NEWPATH:$PATH

#NEWPATH="${HOME}/Projects/petticoat/depot_tools"
#echo $PATH | grep -q "$NEWPATH" || export PATH=$NEWPATH:$PATH

#NEWPATH="${HOME}/Projects/betty/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin"
#echo $PATH | grep -q "$NEWPATH" || export PATH=$NEWPATH:$PATH

export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-
#export CONFIG_L4T=1
#export USE_PRIVATE_LIBGCC=yes
#export DTC=$HOME/Projects/stampede/dtc

# ssh -X 192.168.1.222
if true; then
#jsloan   pts/2        2013-01-25 09:27 (john-sloans-mac-mini.local)
	export XSERVER="`who am i | sed 's/^.*(//;s/).*$//'`"
	if [ "$DISPLAY" != "" ]; then
		:
	elif [ "$XSERVER" = ":0.0" ]; then
		DISPLAY=":0.0"
	elif [ "$XSERVER" = ":0" ]; then
		DISPLAY=":0"
	elif [ "$XSERVER" = "" ]; then
		DISPLAY=":0"
	else
		DISPLAY="$XSERVER:0.0"
	fi
	export DISPLAY
	xhost + 1> /dev/null
fi

export EDITOR=vim

if [ "$DISPLAY" == ":0" ]; then
	:
elif [ "$DISPLAY" == ":0.0" ]; then
	:
else
	pgrep -U jsloan Xvnc4 || vncserver
fi

#export LANG=C
#export LANG="EN_US"
#export LC_ALL="C"
#export LC_CTYPE="en_US.UTF-8"
#export LC_NUMERIC="en_US.UTF-8"
#export LC_TIME="en_US.UTF-8"
#export LC_COLLATE="c"
#export LC_MONETARY="en_US.UTF-8"
#export LC_MESSAGES="en_US.UTF-8"
#export LC_PAPER="en_US.UTF-8"
#export LC_NAME="en_US.UTF-8"
#export LC_ADDRESS="en_US.UTF-8"
#export LC_TELEPHONE="en_US.UTF-8"
#export LC_MEASUREMENT="en_US.UTF-8"
#export LC_IDENTIFICATION="en_US.UTF-8"

PS1='${debian_chroot:+($debian_chroot)}\u@\h:\W\$ '

alias rm="rm -i"

#export LD_DEBUG=files

umask 022

# This majik is needed for GNU Octave.
export GTK_MODULES=gail:atk-bridge:unity-gtk-module 
export GNOME_DESKTOP_SESSION_ID=this-is-depricated 
