com-diag-bin
============

Raspberry Pi backup scripts and other useful Linux shell scripts.

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

At last count I have ten Raspberry Pi single board computers of various
vintages and configurations running 24x7 around the Palatial Overclock
Estate, not to mention some others tucked away in the basement that I
only break out occasionally. Their functions range from stuff like an
Apache web server to a cesium atomic clock. I developed a modest
collection of simple shell scripts to help me deal with their boot
media.

All of the scripts have names starting with "pi". Those that start with
"piimage" deal with binary disk images and/or unmounted storage devices.
Those that start with "pilocal" deal with individual files and mounted
file systems. I run the pilocalbackup script on the Raspberry Pi that
I am backing up; the other scripts can be run on a RPi or another host
accessing the boot media through, for example, a card adapter with a
USB interface.

In the examples below, /dev/sdx is a micro-SD (uSD) card for a Raspberry
PI on which /dev/sdx1 (partition one) is the boot partition and /dev/sdx2
(partition two) is the root partition, and /dev/sdy is the backup
media (e.g. an SSD) with a (for example) ext4 file system on /dev/sdy1
(partition one). It is only by my own personal convention that I
mount the boot (/boot) and root (/) file systems on the mount points
/mnt1 and /mnt2 respectively, and the backup up SSD on /mnt.

"framistat" is a stand-in for a RPi host name. "doodad" is a stand-in
for a Raspbian distribution like "buster".

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

I typically softlink to the scripts in the cloned repo into my local bin
directory and rename the links to drop the ".sh" suffix; that's what is
shown below.

## Determine the Raspbian version from a uSD card.

The partitioning on the standard Raspbian image differs from jessie to stretch to buster.

    sudo mount /dev/sdx2 /mnt2
    cat /mnt2/etc/debian_version
    sudo umount /mnt2

## Determine the Raspbian version from the local backup.

The partitioning on the standard Raspbian image differs from jessie to stretch to buster.

    sudo mount /dev/sdy1 /mnt
    cat /mnt/pi/framistat/etc/debian_version
    sudo umount /mnt

## Install a zipped RPi image on an identical or larger uSD card.

    piimageinstall ./doodad.zip /dev/sdx
    piimageexpand /dev/sdx buster

## Extract the complete RPi image from a uSD card to a zip file.

    piimageextract /dev/sdx ./framistat.zip

## Backup a complete RPi image to a gzipped file.

    piimagecheck /dev/sdx
    piimagebackup /dev/sdx ./framistat.gz

## Restore a gzipped RPi image to an identical or larger uSD card.

    piimagerestore ./framistat.gz /dev/sdx
    piimageexpand /dev/sdx doodad

## Backup files using rsync run locally on an RPi.

I install and run this script locally on the Raspberry Pi itself after mounting the backup media (in my case, a one terabyte USB-attached SSD). The script uses the hostname of the Pi to create a directory on the backup media into which the files are saved. I am currently backing up about twelve different Raspberry Pis running three different versions of Raspbian this way.

    sudo mount /dev/sdy1 /mnt
    pilocalbackup /mnt/pi/framistat
    sudo umount /mnt

## Restore RPi files using rsync to an unused uSD card.

I have successfully recreated the boot uSD card for a Raspberry Pi using this mechanism, run from another host (in my case,m an Intel server running Ubuntu).

    piimageformat /dev/sdx buster
    sudo mount /dev/sdx1 /mnt1
    sudo mount /dev/sdx2 /mnt2
    sudo mount /dev/sdy1 /mnt
    pilocalrestore /mnt/pi/framistat /mnt1 /mnt2
    sudo unmount /mnt /mnt1 /mnt2

## Customize the RPi image on a restored uSD card.

You might not need to customize the Raspberry Pi boot uSD card you restore. But in one case, the original backup was from a NOOBS-based uSD card which has seven partitions, and I created a uSD card with two partitions, boot and root. I also restored a uSD card and then customized it with a different host and IP address, so I could run the same software in parallel on another Raspberry Pi for testing purposes. This was all done on an Intel server running Ubuntu, before I ever tried to boot up the uSD card on the Pi.

    sudo mount /dev/sdx1 /mnt1
    sudo ${EDITOR:-"vi"} /mnt1/cmdline.txt     # To change boot partition.
    sudo umount /mnt1
    
    sudo mount /dev/sdx2 /mnt2
    sudo ${EDITOR:-"vi"} /mnt2/etc/fstab       # To change / and /boot mounts.
    sudo ${EDITOR:-"vi"} /mnt2/etc/dhcpcd.conf # To change IP address.
    sudo ${EDITOR:-"vi"} /mnt2/etc/hostname    # To change host name.
    sudo ${EDITOR:-"vi"} /mnt2/etc/hosts       # To change host name resolution.
    sudo umount /mnt2

## Acknowledgements

<https://raspberrypi.stackexchange.com/questions/5427/can-a-raspberry-pi-be-used-to-create-a-backup-of-itself/28087#28087>

<https://raspberrypi.stackexchange.com/questions/29947/reverse-the-expand-root-fs/29952#29952>

<https://github.com/RPi-Distro/pi-gen/blob/master/export-noobs/00-release/files/partitions.json>
