#!/usr/bin/env bash

echo "Mount point of system partition:"
read syspart
pacstrap $syspart base base-devel linux linux-firmware vim git
genfstab -U $syspart >> $syspart/etc/fstab

sed '1,/^#arch-chroot$/d' archinstall_2.sh > $syspart/archconfig.sh
chmod +x $syspart/archconfig.sh

arch-chroot $syspart ./archconfig.sh
exit

#arch-chroot
ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "KEYMAP=fr" > /etc/vconsole.conf
echo "Hostname? : "
read hostname
echo $hostname > /etc/hostname
echo "127.0.0.1     localhost" >> /etc/hosts
echo "::1           localhost" >> /etc/hosts
echo "127.0.1.1     $hostname.localdomain $hostname" >> /etc/hosts

mkinitcpio -P
passwd

echo "Installing grub, device name: ?"
read device
pacman --noconfirm -S grub
grub-install $device
grub-mkconfig -o /boot/grub/grub.cfg
echo "Installing some necessary programs ... "
pacman -S --noconfirm pulseaudio pulseaudio-alsa alsa-utils networkmanager firefox pamixer vim vi
viduso
echo "Username? : "
read user
useradd -m -G wheel -s /bin/bash $user
passwd $user

echo "Done!"
