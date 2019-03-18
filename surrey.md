# com-diag-surrey

Musings with Automotive Grade Linux (AGL) on a Rasbperry Pi.

## Copyright

Copyright 2019 by the Digital Aggregates Corporation, Colorado, USA.

## License

Original content licensed under the terms of the GNU GPL 2.0.

## Contact

Chip Overclock  
<mailto:coverclock@diag.com>  
Digital Aggregates Corporation  
<http://www.diag.com>  
3440 Youngfield Street, Suite 209  
Wheat Ridge CO 80033 USA  

## Abstract

## Host

"Cadmium"
x86_64 64-bit
Ubuntu 16.04.5 "xenial"
Linux 4.15.0
arm-agl-linux-gnueabi-gcc 6.3.0

## Target

"Surrey"    
ARMv7 64-bit    
Broadcom BCM2837B0 Cortex-A53 @ 1.4GHz x 4      

## Resources

<https://wiki.automotivelinux.org/agl-distro/agl-raspberrypi>

<https://docs.atsgarage.com/quickstarts/automotive-grade-linux.html>

<https://geektillithertz.com/wordpress/index.php/2017/06/09/agl-on-the-raspberry-pi-23/>

## Notes

    mkdir surrey
    cd surrey
    export AGL_TOP=`pwd`
    repo init -b eel -m eel_5.1.0.xml -u https://gerrit.automotivelinux.org/gerrit/AGL/AGL-repo
    repo sync
    # (Must be a Raspberry Pi 3B *not* a 3B+)
    source meta-agl/scripts/aglsetup.sh -f -m raspberrypi3 agl-demo agl-netboot agl-appfw-smack agl-devel
    # (Script does a 'cd build'.)
    bitbake agl-demo-platform
    cd tmp/deploy/images/raspberrypi3
    tail -f /var/log/syslog
    # (Insert SD card into build host; I use a USB adapter. Check device.)
    xzcat agl-demo-platform-raspberrypi3.wic.xz | sudo dd of=/dev/sdb bs=4M status=progress conv=fsync
    sudo parted -s /dev/sdb resizepart 2 '100%'
    sudo e2fsck -f /dev/sdb2
    sudo resize2fs /dev/sdb2
    sync;sync;sync
    mkdir -p ~/mnt1 ~/mnt2
    sudo mount /dev/sdb1 ~/mnt1
    sudo mount /dev/sdb2 ~/mnt2
    vi ~/mnt1/cmdline.txt ~/mnt1/config.txt
    vi ~/mnt2/etc/xdg/weston/weston.ini
    sudo umount ~/mnt1 ~/mnt2

