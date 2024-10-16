#!/bin/bash

ln -sf /usr/share/zoneinfo/America/Sao_Paulo /etc/localtime
hwclock --systohc
sed -i '387s/.//' /etc/locale.gen
locale-gen
echo "LANG=pt_BR.UTF-8" >> /etc/locale.conf
echo "KEYMAP=us-acentos" >> /etc/vconsole.conf
echo "gondor" >> /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 gondor.localdomain gondor" >> /etc/hosts
echo root:password | chpasswd

pacman -S reflector rsync

reflector -c Brazil -a 12 --sort rate --save /etc/pacman.d/mirrorlist

pacman -Syyy

# You can add xorg to the installation packages, I usually add it at the DE or WM install script
# You can remove the tlp package if you are installing on a desktop or vm

pacman -S grub efibootmgr networkmanager network-manager-applet dialog wpa_supplicant mtools dosfstools base-devel linux-lts-headers xdg-user-dirs xdg-utils gvfs nfs-utils inetutils dnsutils bash-completion openssh acpi acpi_call tlp edk2-ovmf bridge-utils dnsmasq vde2 openbsd-netcat ebtables ipset nss-mdns acpid os-prober ntfs-3g terminus-font awesome-terminal-fonts bat exa bpytop zsh libreoffice-fresh libreoffice-fresh-pt-br meld neofetch transmission-gtk ttf-fira-code ttf-fira-mono ttf-font-awesome zathura zathura-djvu zathura-pdf-mupdf zathura-ps gimp gimp-help-pt_br keepassxc p7zip papirus-icon-theme pdftk python-beautifulsoup4 python-pip terminator alsa-utils pipewire pipewire-alsa pipewire-pulse pipewire-jack pavucontrol xorg-xinit fzf wget texstudio less flatpak cmake unzip ninja curl docker-compose yasm cuda cuda-tools nemo nemo-fileroller nemo-preview virt-manager iptables-nft libvirt qemu-full

# pacman -S --noconfirm xf86-video-amdgpu
pacman -S nvidia-lts nvidia-utils nvidia-settings linux-headers

grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager
#systemctl enable bluetooth
#systemctl enable cups.service
systemctl enable sshd
#systemctl enable avahi-daemon
systemctl enable tlp # You can comment this command out if you didn't install tlp, see above
systemctl enable reflector.timer
systemctl enable fstrim.timer
systemctl enable libvirtd
#systemctl enable firewalld
systemctl enable acpid
systemctl enable docker

useradd -m jfreitas

usermod -aG libvirt jfreitas

usermod -aG docker jfreitas

touch /etc/sudoers.d/jfreitas

echo "jfreitas ALL=(ALL) ALL" >> /etc/sudoers.d/jfreitas

timedatectl set-local-rtc 1

printf "\e[1;32mDone! Type exit, umount -a and reboot.\e[0m"
