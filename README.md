com-diag-bin
============

Useful little scripts.

# Abstract

[![Say Thanks!](https://img.shields.io/badge/Say%20Thanks-!-1EAEDB.svg)](https://saythanks.io/to/coverclock)

This are just odds and ends, mostly little scripts that I have found useful,
and which I install on pretty much every Linux system I use.

# License

You can assume that they are all licensed under the GNU Public
License version 2.

# Contact

Chip Overclock    
Digital Aggregates Corporation    
3440 Youngfield Street, Suite 209    
Wheat Ridge CO 80033 USA    
http://www.diag.com    
mailto:coverclock@diag.com    

# Notes

The scripts to manage boot media, including backups and restores, for
Raspberry Pi single board computers have not been extensively tested.

# Examples

## Extract the complete image from an SD card.

    piimageextract /dev/sdb ./framistat.img

## Install a complete image on an identical or larger SD card.

    piimageinstall ./framistat.img /dev/sdb
    piimageexpand /dev/sdb buster
    piimagecheck /dev/sdb

## Backup files using rsync.

    mount /dev/sdc1 /mnt
    pilocalbackup
    umount /mnt

## Restore files using rsync.

    piimageformat /dev/sdb buster
    mount /dev/sdb1 /mnt1
    mount /dev/sdb2 /mnt2
    mount /dev/sdc /mnt
    pilocalrestore /mnt/pi/framistat /mnt1 /mnt2
    unmount /mnt /mnt1 /mnt2
    piimagecheck /dev/sdb
    piimageexpand /dev/sdb buster
    piimagecheck /dev/sdb

## Backup a complete image.

    piimagecheck /dev/sdb
    piimagebackup /dev/sdb ./framistat.gz

## Restore a complete image to an identical or larger SD card.

    piimagerestore ./framistat.gz /dev/sdb
    piimagecheck /dev/sdb
    piimageexpand /dev/sdb buster
    piimagecheck /dev/sdb

## Customize a restored SD card.

    mount /dev/sdb1 /mnt1
    mount /dev/sdb2 /mnt2
    ${EDITOR:-"vi"} /mnt1/cmdline.txt     # To change boot partition.
    ${EDITOR:-"vi"} /mnt2/etc/fstab       # To change / and /boot mounts.
    ${EDITOR:-"vi"} /mnt2/etc/dhcpcd.conf # To change static IP address.
    ${EDITOR:-"vi"} /mnt2/etc/hostname    # To change host name.
    ${EDITOR:-"vi"} /mnt2/etc/hosts       # To change host name resolution.
    umount /mnt1
    umount /mnt2
