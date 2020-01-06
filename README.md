com-diag-bin
============

Useful little Linux shell scripts.

# Abstract

[![Say Thanks!](https://img.shields.io/badge/Say%20Thanks-!-1EAEDB.svg)](https://saythanks.io/to/coverclock)

This are just odds and ends, mostly little scripts that I have found useful
but are not specific to a particular project.

# License

Licensed under the GNU Public License version 2.

# Contact

Chip Overclock    
Digital Aggregates Corporation    
3440 Youngfield Street, Suite 209    
Wheat Ridge CO 80033 USA    
http://www.diag.com    
mailto:coverclock@diag.com    

# Examples of Managing Raspberry Pi (RPi) Boot Media

All of the scripts have names starting with "pi". Those that start with
"piimage" deal with binary disk images and/or unmounted storage devices.
Those that start with "pilocal" deal with mounted file systems. The
pilocalbackup script is intended to be run on the Raspberry Pi that
you are backing up; the other scripts can be run on a RPi or another
host.

In the examples below, /dev/sdx is a micro-SD (uSD) card for a Raspberry
PI on which /dev/sdx1 (partition one) is the boot partition and /dev/sdx2
(partition two) is the root partition, and /dev/sdy is the backup
media (e.g. an SSD) with a (for example) ext4 file system on /dev/sdy1
(partition one). "framistat" is a stand-in for a RPi host name. "doodad" is
a stand-in for a Raspbian distribution like "buster".

The partitioning of the uSD card depends on the Raspbian verion,
and the scripts make use of the version code name: "jessie" for 8.x,
"stretch" for 9.x, and "buster" for 10.x. This partitioning mimics the
two partition pattern found in the standard Raspbian image distributions,
*not* the Noobs distributions which has more partitions.

The Raspbian disk images from the RaspberryPi.org web site are compressed
using zip, and that is the format used by the piimageinstall and
piimageextract scripts. The piimagebackup and piimagerestore scripts use
gzip compression instead. In either case, these tools are only useful if
you load the image onto a uSD card that is the same size (and, typically,
the same brand and model) or a larger size than the uSD card from which
they were copied. And in either case, the piimageexpand script can be
used to expand the root file system to use the remainder of the uSD card.

## Determine the Raspbian version from a uSD card.

    mount /dev/sdx2 /mnt2
    cat /mnt2/etc/debian_version
    umount /mnt2

## Determine the Raspbian version from the local backup.

    mount /dev/sdy1 /mnt
    cat /mnt/pi/framistat/etc/debian_version
    umount /mnt

## Install a zipped RPi image on an identical or larger uSD card.

    piimageinstall ./doodad.zip /dev/sdx
    piimageexpand /dev/sdx buster

## Extract the complete RPi image from a uSD card to a zip file.

    piimageextract /dev/sdx ./framistat.zip

## Backup files using rsync run locally on an RPi.

    mount /dev/sdy1 /mnt
    pilocalbackup
    umount /mnt

## Restore RPi files using rsync to an unused uSD card.

    piimageformat /dev/sdx buster
    mount /dev/sdx1 /mnt1
    mount /dev/sdx2 /mnt2
    mount /dev/sdy1 /mnt
    pilocalrestore /mnt/pi/framistat /mnt1 /mnt2
    unmount /mnt /mnt1 /mnt2

## Backup a complete RPi image to a gzipped file.

    piimagecheck /dev/sdx
    piimagebackup /dev/sdx ./framistat.gz

## Restore a gzipped RPi image to an identical or larger uSD card.

    piimagerestore ./framistat.gz /dev/sdx
    piimageexpand /dev/sdx buster

## Customize the RPi image on a restored uSD card.

    mount /dev/sdx1 /mnt1
    ${EDITOR:-"vi"} /mnt1/cmdline.txt     # To change boot partition.
    umount /mnt1
    
    mount /dev/sdx2 /mnt2
    ${EDITOR:-"vi"} /mnt2/etc/fstab       # To change / and /boot mounts.
    ${EDITOR:-"vi"} /mnt2/etc/dhcpcd.conf # To change IP address.
    ${EDITOR:-"vi"} /mnt2/etc/hostname    # To change host name.
    ${EDITOR:-"vi"} /mnt2/etc/hosts       # To change host name resolution.
    umount /mnt2
