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

The scripts to manage boot media, including backups and restores, for
the Raspberry Pi single board computer are still being tested, being a
recent addition.

## Extract the complete RPi image from an SD card.

    piimageextract /dev/sdb ./framistat.img

## Install a complete RPi image on an identical or larger SD card.

    piimageinstall ./framistat.img /dev/sdb
    piimageexpand /dev/sdb buster
    piimagecheck /dev/sdb

## Backup files using rsync run locally on an RPi.

    mount /dev/sdc1 /mnt
    pilocalbackup
    umount /mnt

## Restore RPi files using rsync to an unused SD card.

    piimageformat /dev/sdb buster
    mount /dev/sdb1 /mnt1
    mount /dev/sdb2 /mnt2
    mount /dev/sdc /mnt
    pilocalrestore /mnt/pi/framistat /mnt1 /mnt2
    unmount /mnt /mnt1 /mnt2
    piimagecheck /dev/sdb
    piimageexpand /dev/sdb buster
    piimagecheck /dev/sdb

## Backup a complete RPi image.

    piimagecheck /dev/sdb
    piimagebackup /dev/sdb ./framistat.gz

## Restore a complete RPi image to an identical or larger SD card.

    piimagerestore ./framistat.gz /dev/sdb
    piimagecheck /dev/sdb
    piimageexpand /dev/sdb buster
    piimagecheck /dev/sdb

## Customize the RPi image on a restored SD card.

    mount /dev/sdb1 /mnt1
    mount /dev/sdb2 /mnt2
    ${EDITOR:-"vi"} /mnt1/cmdline.txt     # To change boot partition.
    ${EDITOR:-"vi"} /mnt2/etc/fstab       # To change / and /boot mounts.
    ${EDITOR:-"vi"} /mnt2/etc/dhcpcd.conf # To change IP address.
    ${EDITOR:-"vi"} /mnt2/etc/hostname    # To change host name.
    ${EDITOR:-"vi"} /mnt2/etc/hosts       # To change host name resolution.
    umount /mnt1
    umount /mnt2
