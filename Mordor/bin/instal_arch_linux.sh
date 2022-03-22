#!/bin/bash

ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
hwclock --systohc
sed -i '393s/.//' /etc/locale.gen
locale-gen
echo "LANG=pt_BR.UTF-8" >> /etc/locale.conf
echo "KEYMAP=us-acentos" >> /etc/vconsole.conf
echo "mordor" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 mordor.localdomain gondor" >> /etc/hosts
echo root:password | chpasswd

pacman -S --noconfirm reflector rsync

reflector -c Brazil,'United States' -a 12 --sort rate --save /etc/pacman.d/mirrorlist

pacman -Syyy

# You can add xorg to the installation packages, I usually add it at the DE or WM install script
# You can remove the tlp package if you are installing on a desktop or vm

pacman -S --noconfirm base-devel linux-headers grub efibootmgr networkmanager network-manager-applet dialog mtools dosfstools base-devel xdg-user-dirs xdg-utils gvfs nfs-utils inetutils dnsutils bash-completion openssh acpi acpi_call virt-manager qemu qemu-arch-extra edk2-ovmf bridge-utils dnsmasq vde2 openbsd-netcat ebtables ipset nss-mdns acpid terminus-font awesome-terminal-fonts bat exa bpytop zsh meld neofetch texinfo texlive-bibtexextra texlive-core texlive-fontsextra texlive-formatsextra texlive-latexextra texlive-pictures texlive-pstricks texlive-publishers texlive-science ttf-fira-code ttf-fira-mono ttf-font-awesome zathura zathura-djvu zathura-pdf-mupdf zathura-ps keepassxc p7zip papirus-icon-theme pdftk terminator alsa-utils pulseaudio pulseaudio-alsa pavucontrol xorg-xinit fzf cups hplip polkit lxqt-policykit

pacman -S --noconfirm mesa vulkan-radeon

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager
#systemctl enable bluetooth
systemctl enable cups.service
systemctl enable sshd
#systemctl enable avahi-daemon
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable libvirtd
#systemctl enable firewalld
systemctl enable acpid

useradd -m jfreitas
echo jfreitas:estudos | chpasswd
usermod -aG libvirt jfreitas

touch /etc/sudoers.d/jfreitas

echo "jfreitas ALL=(ALL) ALL" >> /etc/sudoers.d/jfreitas

printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"
