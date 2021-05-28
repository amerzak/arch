#!/usr/bin/env bash
#
# My arch installation process automated

echo "My Arch Install !"
pacman --noconfirm -Sy archlinux-keyring
loadkeys fr
timedatectl set-ntp true

lsblk
echo "Enter device:"
read device
fdisk $device
echo "Now make files systems and mount the partitions manually"
