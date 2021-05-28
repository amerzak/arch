#!/usr/bin/env bash
clear
echo "My arch installer!"
pacman --noconfirm archlinux-keyring
loadkeys fr
timedatectl set-ntp true
clear && lsblk
echo "Enter device name: "
read device
fdisk $device
echo "Now! Mount and make file systems on partitions manually"
sed '1,/^#install$/d' $0 > archinstall_2.sh
exit

#install
clear
echo "Mount point of system partition (full path):"
read syspart
pacstrap $syspart base base-devel linux linux-firmware vim git
genfstab -U $syspart >> $syspart/etc/fstab

sed '1,/^#config$/d' $0 > $syspart/archconfig.sh
chmod +x $syspart/archconfig.sh
arch-chroot $syspart ./archconfig.sh
exit

#config
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
clear
lsblk
echo "Installing grub, device: ?"
read device
pacman --noconfirm -S grub
grub-install $device
grub-mkconfig -o /boot/grub/grub.cfg
echo "Installing some necessary programs ... "
pacman -S --noconfirm pulseaudio pulseaudio-alsa alsa-utils networkmanager firefox pamixer vim vi
git clone https://aur.archlinux.org/yay.git && cd yay
makepkg -si PKGBUILD
echo "Username? : "
read user
useradd -m -G wheel -s /bin/bash $user
passwd $user
visudo
echo "Done!"
