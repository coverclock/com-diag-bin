ABSTRACT

[![Say Thanks!](https://img.shields.io/badge/Say%20Thanks-!-1EAEDB.svg)](https://saythanks.io/to/coverclock)

This are just odds and ends, mostly little scripts that I have found useful,
and which I install on pretty much every Linux system I use. You can assume
that they are all licensed under the GNU Public License version 2.

CONTACT

    Chip Overclock
    Digital Aggregates Corporation
    3440 Youngfield Street, Suite 209
    Wheat Ridge CO 80033 USA
    http://www.diag.com
    mailto:coverclock@diag.com

NOTES

The scripts to manage boot media, including backups and restores, for
Raspberry Pi single board computers have not been extensively tested.

EXAMPLES

    piimageextract /dev/sdb ./framistat.img

    piimageinstall ./framistat.img /dev/sdb
    piimageexpand /dev/sdb buster
    piimagecheck /dev/sdb

    mount /dev/sdc1 /mnt
    pilocalbackup
    umount /mnt

    piimageformat /dev/sdb buster
    mount /dev/sdb1 /mnt1
    mount /dev/sdb2 /mnt2
    mount /dev/sdc /mnt
    pilocalrestore /mnt/pi/framistat /mnt1 /mnt2
    unmount /mnt /mnt1 /mnt2
    piimagecheck /dev/sdb
    piimageformat /dev/sdb buster

    piimagecheck /dev/sdb
    piimagebackup /dev/sdb ./framistat.gz

    piimagerestore ./framistat.gz /dev/sdb
    piimageexpand /dev/sdb buster
    piimagecheck /dev/sdb

