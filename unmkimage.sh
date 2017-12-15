#!/bin/bash -x
# Usage:     unmkimage.sh
# Example:   unmkimage.sh < rootfs_hybrid_ram.cpio.uImage > rootfs_hybrid_ram.cpio
# Abstract:  Extract the contents of an image created by mkimage from uboot-mkimage.
# Artifact:  Contents (which could be anything) written to stdout.
# Status:    TESTED
# Author:    jsloan@diag.com

dd bs=64 skip=1 | zcat
