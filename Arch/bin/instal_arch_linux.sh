#!/bin/bash

ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
hwclock --systohc
sed -i '391s/.//' /etc/locale.gen
locale-gen
echo "LANG=pt_BR.UTF-8" >> /etc/locale.conf
echo "KEYMAP=br-abnt2" >> /etc/vconsole.conf
echo "gondor" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 gondor.localdomain gondor" >> /etc/hosts
echo root:password | chpasswd

pacman -S reflector rsync

reflector -c Brazil -a 12 --sort rate --save /etc/pacman.d/mirrorlist

pacman -Syyy

pacman -S acpi acpi_call acpid alsa-utils awesome-terminal-fonts base-devel bash-completion bat bpytop bridge-utils cmake curl dialog dnsmasq dnsutils dosfstools ebtables edk2-ovmf efibootmgr grub gvfs inetutils ipset iptables-nft less libvirt linux-lts-headers mtools network-manager-applet networkmanager nfs-utils nss-mdns ntfs-3g openbsd-netcat openssh os-prober pacman-contrib p7zip pipewire pipewire-alsa pipewire-jack pipewire-pulse python-beautifulsoup4 python-pip qemu-full terminus-font tlp ttf-fira-code ttf-fira-mono ttf-font-awesome unzip vde2 virt-manager wget wpa_supplicant xdg-user-dirs xdg-utils xorg-xinit zsh bluez bluez-utils

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB

grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable sshd
systemctl enable tlp
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable libvirtd

useradd -m jfreitas

usermod -aG libvirt jfreitas

touch /etc/sudoers.d/jfreitas

echo "jfreitas ALL=(ALL) ALL" >> /etc/sudoers.d/jfreitas

timedatectl set-local-rtc 1

printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"
