#!/usr/bin/env bash

set -e
set -u
set -o pipefail
set -x

ln -sf /usr/share/zoneinfo/Australia/Perth /etc/localtime

sed -i -E -e 's/#(en_AU\.UTF-8\s+UTF-8)/\1/' /etc/locale.gen
sed -i -E -e 's/#(en_US\.UTF-8\s+UTF-8)/\1/' /etc/locale.gen
locale-gen

echo 'LANG=en_AU.UTF-8' > /etc/locale.conf

echo 'KEYMAP=dvorak' > /etc/vconsole.conf

echo 'arch' > /etc/hostname

echo '127.0.0.1 localhost' >> /etc/hosts
echo '::1 localhost' >> /etc/hosts

echo -e 'root\nroot\n' | passwd

pacman -S --noconfirm dhcpcd
systemctl enable dhcpcd.service
