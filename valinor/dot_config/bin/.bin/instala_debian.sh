#!/bin/bash

#Para btrfs, olhar também https://medium.com/@inatagan/installing-debian-with-btrfs-snapper-backups-and-grub-btrfs-27212644175f

sudo apt install snapper gawk inotify-tools

git clone https://github.com/Antynea/grub-btrfs

cd grub-btrfs

sudo make install

cd ~

sudo rm grub-btrfs

#Atualizando firmware

sudo fwupdmgr refresh --force
sudo fwupdmgr get-devices
sudo fwupdmgr get-updates
sudo fwupdmgr update

#Instala o curl, git, npm, nodejs

sudo apt install curl git nodejs npm build-essential automake python3.13-venv checkinstall lm-sensors gir1.2-gtk-4.0 bc kmod cpio flex libncurses-dev libelf-dev libssl-dev dwarves bison libdw-dev debhelper-compat gnome-text-editor -y

sudo npm install -g tree-sitter-cli

#Alguns pacotes do Gnome

sudo apt install gnome-text-editor dconf-editor libnotify-dev gparted python3-nautilus gnome-shell-extensions -y

#Instala o Brave

sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list

sudo apt update

sudo apt install brave-browser -y

#Instala o sublime text

wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg >/dev/null

echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

sudo apt update

sudo apt install sublime-text -y

#Instalação do neovim

sudo apt install ninja-build gettext cmake build-essential -y

git clone https://github.com/neovim/neovim

cd neovim/

git checkout stable

make CMAKE_BUILD_TYPE=RelWithDebInfo

cd build && cpack -G DEB

sudo dpkg -i nvim-linux-x86_64.deb

cd ~

rm -rf neovim

#Instalação do onedrive

sudo apt install build-essential libcurl4-openssl-dev libsqlite3-dev pkg-config systemd-dev libdbus-1-dev -y

curl -fsS https://dlang.org/install.sh | bash -s dmd

DLANG=$(/usr/bin/ls ~/dlang/ | grep dmd | awk '{print $1}')

source ~/dlang/$DLANG/activate

git clone https://github.com/abraunegg/onedrive.git

cd onedrive

./configure

make clean

make

sudo checkinstall --install=no

deactivate

sudo dpkg -i onedrive*.deb

cd ~

rm -rf dlang

sudo rm -rf onedrive

#Fontes

sudo apt install ttf-mscorefonts-installer fontconfig libfontconfig1-dev -y

#Pacotes de propósito geral

sudo apt install bat bzip2 eza feh flatpak fzf p7zip p7zip-full pdftk ranger rsync vlc zathura zathura-cb zathura-djvu zathura-pdf-poppler zathura-ps meld imagemagick xz-utils fd-find zoxide ripgrep luarocks xclip ffmpeg ffmpegthumbnailer htop autoconf gcc make pkg-config poppler-utils img2pdf lazygit -y

#Virtualização

sudo apt install qemu-utils qemu-system-x86 qemu-system-gui virt-manager virtiofsd -y

sudo usermod -aG libvirt jfreitas

sudo rm -rf /etc/libvirt/qemu

sudo rm -rf /etc/libvirt/qemu.conf

sudo rm -rf /etc/libvirt/storage

sudo ln -s ~/GitHub/dot/valinor/maquinas_virtuais/qemu /etc/libvirt/

sudo ln -s ~/GitHub/dot/valinor/maquinas_virtuais/storage /etc/libvirt/

sudo ln -s /home/jfreitas/GitHub/dot/valinor/maquinas_virtuais/qemu.conf /etc/libvirt/

sudo systemctl enable libvirtd --now

#R

sudo apt install lib32gcc-s1 lib32stdc++6 libc6-i386 libclang-19-dev libclang-common-19-dev libclang-dev libclang-rt-19-dev libclang1-19 libobjc-14-dev libobjc4 r-base -y

#ZSH e terminal

sudo apt install zsh alacritty -y

sudo chsh -s $(which zsh) jfreitas

cd ~

git clone https://github.com/zplug/zplug ~/.local/share/zplug

#LaTeX

sudo apt install texlive texlive-base texlive-bibtex-extra texlive-binaries texlive-extra-utils texlive-fonts-extra texlive-fonts-recommended texlive-font-utils texlive-formats-extra texlive-lang-portuguese texlive-latex-base texlive-latex-extra texlive-latex-recommended texlive-luatex texlive-pictures texlive-plain-generic texlive-pstricks texlive-science texlive-xetex latexmk latex-cjk-all texstudio -y

#TMUX

sudo apt install tmux -y

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

#Dependências para o Manim

sudo apt install -y python3-dev libpango1.0-dev libcairo2-dev pkg-config

#Sway

sudo apt install sway wofi waybar swaylock wlogout cliphist swayidle network-manager-applet wl-clipboard dunst blueman -y

echo 'NotShowIn=Gnome;' | sudo tee -a /etc/xdg/autostart/blueman.desktop

python3 -m venv ~/.local/src/venv/

cd ~/.local/src/venv/bin/

./pip install stacki3

cd ~

#Hyprland, somente no testing

sudo apt install hyprland hyprland-protocols hyprpicker hyprland-qtutils hyprcursor-util hyprpaper hypridle hyprlock wofi waybar wlogout cliphist network-manager-applet wl-clipboard dunst blueman sway-notification-center -y

echo 'NotShowIn=Gnome;' | sudo tee -a /etc/xdg/autostart/blueman.desktop

#Xmonad

#sudo apt install xmonad xmobar yad suckless-tools volumeicon-alsa pcmanfm lxappearance pavucontrol picom adwaita-icon-theme arandr autorandr nemo nemo-fileroller -y

#FSTRIM

sudo systemctl enable fstrim.timer

#Atualizando o GRUB

sudo rm /etc/default/grub

sudo ln -s ~/GitHub/dot/valinor/grub/grub /etc/default/grub

sudo update-grub2

#Hibernação

sudo rm -rf /etc/systemd/sleep.conf

sudo rm -rf /etc/systemd/logind.conf

sudo ln -s ~/GitHub/dot/valinor/logind/sleep.conf /etc/systemd/sleep.conf

sudo ln -s ~/GitHub/dot/valinor/logind/logind.conf /etc/systemd/logind.conf

sudo ln -s /usr/lib/systemd/system/systemd-suspend-then-hibernate.service /etc/systemd/system/systemd-suspend.service

#Stow

sudo apt install stow -y

rm -rf ~/.config

cd ~/GitHub/dot/valinor/dot_config/

stow -t /home/jfreitas/ *

cd ~/.local/share

ln -s ~/GitHub/dot/fonts ./

cd ~/.local/share/fonts/

fc-cache -f -v

cd ~

#Flatpaks

sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install flathub com.bitwarden.desktop -y

flatpak install flathub io.github.shiftey.Desktop -y

flatpak install flathub com.github.PintaProject.Pinta -y

flatpak install flathub com.spotify.Client -y

flatpak install flathub com.github.xournalpp.xournalpp -y

flatpak install flathub org.geogebra.GeoGebra -y

flatpak install flathub org.keepassxc.KeePassXC -y

#flatpak install flathub org.texstudio.TeXstudio -y

#Atuin, starship e uv

curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh

curl -sS https://starship.rs/install.sh | sh

curl -LsSf https://astral.sh/uv/install.sh | sh

#Instando kernel atual

#sudo apt install -t trixie-backports linux-image-amd64 firmware-linux firmware-linux-nonfree -y

#Firefox e Libreoffice

sudo apt install firefox-esr libreoffice libreoffice-l10n-pt-br -y

#Removendo programas e desativando serviços

sudo apt remove -y cups cups-common apache2-bin libapache2-mod-dnssd php-cli php-mbstring --purge

sudo apt autoremove -y

sudo systemctl disable ModemManager.service

sudo systemctl disable avahi-daemon.service

sudo systemctl disable avahi-daemon.socket

sudo timedatectl set-local-rtc 1
