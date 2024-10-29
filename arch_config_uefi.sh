#!/bin/bash

ln -sf /usr/share/zoneinfo/America/Santo_Domingo /etc/localtime
hwclock --systohc

sed -i '190s/.//' /etc/locale.gen
locale-gen
echo "LANG=es_DO.UTF-8" >> /etc/locale.conf
echo "LC_COLLATE=C" >> /etc/locale.conf
echo "KEYMAP=us-acentos" >> /etc/vconsole.conf
echo "FONT=ter-120b" >> /etc/vconsole.conf

echo "[zram0]" >> /etc/systemd/zram-generator.conf
echo "zram-size = min(ram, 8192)" >> /etc/systemd/zram-generator.conf
echo "compression-algorithm = zstd" >> /etc/systemd/zram-generator.conf

echo "arch" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 arch.localdomain arch" >> /etc/hosts
systemctl enable NetworkManager

sed -i '63s/.//' /etc/default/grub
mkinitcpio -P
grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

echo root:passwd | chpasswd
useradd -m user
usermod -aG sys,network,scanner,power,rfkill,users,video,storage,optical,lp,audio,wheel user
echo user:passwd | chpasswd
sed -i '121s/.//' /etc/sudoers
sed -i '121s/.//' /etc/sudoers

sed -i '33s/.//' /etc/pacman.conf
sed -i '37s/.//' /etc/pacman.conf
sed -i '92s/.//' /etc/pacman.conf
sed -i '93s/.//' /etc/pacman.conf
pacman -Syu

printf "\n\e[1;96mDone! \e[0m\n"
