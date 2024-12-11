com-diag-bin
============

Linux shell scripts I have known and loved.

# Copyright

Copyright 2014-2024 by the Digital Aggregates Corporation, Colorado, USA.

Except where noted, this software is an original work of its author.

# License

Licensed under the terms in LICENSE.txt. 

# Trademarks

"Digital Aggregates Corporation" is a registered trademark of the Digital
Aggregates Corporation, Arvada, Colorado, USA.

"Chip Overclock" is a registered trademark of John Sloan, Arvada, Colorado,
USA.

# Abstract

This are just odds and ends, mostly little scripts that I have found useful
but are not specific to a particular project. Only a very few of them are
documented here.

# Contact

Chip Overclock    
Digital Aggregates Corporation    
3440 Youngfield Street, Suite 209    
Wheat Ridge CO 80033 USA    
http://www.diag.com    
mailto:coverclock@diag.com    

# Script prefixes

Some of the scripts have special prefixes to their names to clue you into
what platform they are used for. Other scripts are generally platform
agnostic.

* or - scripts that are specific to the Orange Pi (Rockchip ARM processor).
* pi - scripts that are specific to the Raspberry Pi (Broadcom ARM processor).
* v5 - scripts that are specific to the VisionFive (StarFive RISC-V processor).

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

"Offline" means I run the script on another Linux system, typically an Intel
machine running Ubuntu, although it could be another Raspberry Pi running
Raspbian. "Online" means I run the script on the Raspberry Pi itself.

## Determine the Raspbian version from a uSD card offline.

The partitioning on the standard Raspbian image differs from jessie to stretch to buster.

    sudo mount /dev/sdx2 /mnt2
    cat /mnt2/etc/debian_version
    sudo umount /mnt2

## Determine the Raspbian version from the local backup offline.

The partitioning on the standard Raspbian image differs from jessie to stretch to buster.

    sudo mount /dev/sdy1 /mnt
    cat /mnt/pi/framistat/etc/debian_version
    sudo umount /mnt

## Install a zipped RPi image on an identical or larger uSD card offline.

This uses zip instead of gzip because that's the format that Raspbian
disk images are distributed in by the Raspberry Pi organization.

    piimageinstall ./doodad.zip /dev/sdx
    piimageexpand /dev/sdx buster

## Install an xzipped RPi image on an identical or larger uSD card offline.

The later versions of Raspberry Pi OS (the artist formerly known as
Raspbian, a name I insist on still using) use xv as a compression format.
The install process that is invoked when this media is booted on the Pi
will expand the root file system to fill the entire uSD card.

    piimageinstallxz 2024-11-19-raspios-bookworm-arm64-full.img.xz /dev/sdb

## Extract the complete RPi image from a uSD card to a zip file offline.

    piimageextract /dev/sdx ./framistat.zip

## Backup a complete RPi image to a gzipped file offline.

    piimagecheck /dev/sdx
    piimagebackup /dev/sdx ./framistat.gz

## Restore a gzipped RPi image to an identical or larger uSD card offline.

    piimagerestore ./framistat.gz /dev/sdx
    piimageexpand /dev/sdx doodad

## Backup files using rsync online.

I install and run this script locally on the Raspberry Pi itself after mounting the backup media (in my case, a one terabyte USB-attached SSD). The script uses the hostname of the Pi to create a directory on the backup media into which the files are saved. I am currently backing up about twelve different Raspberry Pis running three different versions of Raspbian this way.

    sudo mount /dev/sdy1 /mnt
    pilocalbackup /mnt/pi/framistat
    sudo umount /mnt

## Restore RPi files using rsync to an unused uSD card offline.

I have successfully recreated the boot uSD card for a Raspberry Pi using this mechanism, run from another host (in my case,m an Intel server running Ubuntu).

    piimageformat /dev/sdx buster
    sudo mount /dev/sdx1 /mnt1
    sudo mount /dev/sdx2 /mnt2
    sudo mount /dev/sdy1 /mnt
    pilocalrestore /mnt/pi/framistat /mnt1 /mnt2
    sudo unmount /mnt /mnt1 /mnt2

## Customize the RPi image on a restored uSD card offline.

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

# Software Updates and Installs From X11 Server

    ssh -Y HOSTNAME
    sudo update-manager
    sudo synaptic

# Add Existing User to Group dialout

    sudo usermod -a -G dialout coverclock

# Copy from One USB Serial Adapter to Another

    socat OPEN:/dev/ttyUSB0,b115200,cs8,rawer,nonblock,clocal /dev/tty

    socat OPEN:/dev/ttyUSB1,b115200,cs8,rawer,nonblock,clocal /dev/tty

# Controlling Wireless Interfaces on Raspberry Pi

    sudo rfkill list

    0: phy0: Wireless LAN
	    Soft blocked: yes
	    Hard blocked: no
    1: hci0: Bluetooth
	    Soft blocked: yes
	    Hard blocked: no

    sudo rfkill block 0
    sudo rfkill unblock 0
    sudo rfkill event | cat

# Configuring Raspberry Pi from a ANSI Terminal

    raspi-config

# Samsung T5 1TB SSD on Raspberry Pi

    Nov 13 09:38:43 emerald kernel: [97036.205395] usb 2-1: new SuperSpeed Gen 1 USB device number 2 using xhci_hcd
    Nov 13 09:38:43 emerald kernel: [97036.244948] usb 2-1: New USB device found, idVendor=04e8, idProduct=61f5, bcdDevice= 1.00
    Nov 13 09:38:43 emerald kernel: [97036.244965] usb 2-1: New USB device strings: Mfr=2, Product=3, SerialNumber=1
    Nov 13 09:38:43 emerald kernel: [97036.244980] usb 2-1: Product: Portable SSD T5
    Nov 13 09:38:43 emerald kernel: [97036.244994] usb 2-1: Manufacturer: Samsung
    Nov 13 09:38:43 emerald kernel: [97036.245007] usb 2-1: SerialNumber: 1234568941AC
    Nov 13 09:38:43 emerald kernel: [97036.273572] scsi host0: uas
    Nov 13 09:38:43 emerald kernel: [97036.283909] scsi 0:0:0:0: Direct-Access     Samsung  Portable SSD T5  0    PQ: 0 ANSI: 6
    Nov 13 09:38:43 emerald kernel: [97036.287116] sd 0:0:0:0: [sda] 1953525168 512-byte logical blocks: (1.00 TB/932 GiB)
    Nov 13 09:38:43 emerald kernel: [97036.287413] sd 0:0:0:0: [sda] Write Protect is off
    Nov 13 09:38:43 emerald kernel: [97036.287430] sd 0:0:0:0: [sda] Mode Sense: 43 00 00 00
    Nov 13 09:38:43 emerald kernel: [97036.288085] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't support DPO or FUA
    Nov 13 09:38:43 emerald kernel: [97036.289153] sd 0:0:0:0: [sda] Optimal transfer size 33553920 bytes
    Nov 13 09:38:43 emerald mtp-probe: checking bus 2, device 2: "/sys/devices/platform/scb/fd500000.pcie/pci0000:00/0000:00:00.0/0000:01:00.0/usb2/2-1"
    Nov 13 09:38:43 emerald mtp-probe: bus: 2, device: 2 was not an MTP device
    Nov 13 09:38:43 emerald kernel: [97036.358205]  sda: sda1
    Nov 13 09:38:43 emerald mtp-probe: checking bus 2, device 2: "/sys/devices/platform/scb/fd500000.pcie/pci0000:00/0000:00:00.0/0000:01:00.0/usb2/2-1"
    Nov 13 09:38:43 emerald mtp-probe: bus: 2, device: 2 was not an MTP device
    Nov 13 09:38:43 emerald kernel: [97036.361273] sd 0:0:0:0: [sda] Attached SCSI disk
    Nov 13 09:38:43 emerald kernel: [97036.387775] sd 0:0:0:0: Attached scsi generic sg0 type 0

    sudo fdisk -l /dev/sda

    Disk /dev/sda: 931.5 GiB, 1000204886016 bytes, 1953525168 sectors
    Disk model: Portable SSD T5
    Units: sectors of 1 * 512 = 512 bytes
    Sector size (logical/physical): 512 bytes / 512 bytes
    I/O size (minimum/optimal): 512 bytes / 33553920 bytes
    Disklabel type: dos
    Disk identifier: 0xe2c929f4
    
    Device     Boot Start        End    Sectors   Size Id Type
    /dev/sda1        2048 1953522112 1953520065 931.5G  7 HPFS/NTFS/exFAT

# Install On-Screen Keyboard on Raspberry Pi

    sudo apt install matchbox-keyboard

# Rotate LCD Display on Raspberry Pi

    sudo su
    echo "lcd_rotate=2" >> /boot/config.txt

# Typical git Configurations

    git config --global user.email "you@example.com"
    git config --global user.name "Your Name"

    git config credential.helper cache

    sudo apt-get install git-lfs

# Allow Debian Release Info Change

    apt-get update --allow-releaseinfo-change

# Kernel Building

    sudo apt-get install build-essential bc kmod cpio flex libncurses5-dev libelf-dev libssl-dev dwarves bison

    make ARCH=riscv mrproper

    make ARCH=riscv starfive_visionfive2_defconfig

    make ARCH=riscv menuconfig

    make ARCH=riscv -j4

    sudo make ARCH=riscv INSTALL_PATH=/boot/boot zinstall -j4

    sudo make ARCH=riscv INSTALL_MOD_PATH=/ modules_install

    make -C ${HOME}/src/linux M=$PWD

    make -C /lib/modules/$(uname -r)/build M=${PWD}

    sudo make -C /lib/modules/$(uname -r)/build M=${PWD} modules_install
