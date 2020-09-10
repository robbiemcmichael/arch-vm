#!/usr/bin/env bash

set -e
set -u
set -o pipefail
set -x

mount -o loop /opt/build/vm.raw /mnt

pacstrap /mnt base linux linux-firmware

cp /etc/fstab /mnt/etc/fstab
cp /opt/scripts/configure.sh /mnt/root/configure.sh

arch-chroot /mnt /root/configure.sh
