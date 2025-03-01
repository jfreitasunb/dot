#!/bin/bash
cd ~

#sudo apt install nala

sudo apt install -y curl ninja-build gettext cmake unzip build-essential python3-pip git python3-apt python3-debian pandoc wget php-cli php-mbstring unzip libffi-dev libgmp-dev libx11-dev libxrandr-dev libxinerama-dev libxss-dev pkg-config libxft-dev xorg-dev libxrandr-dev libpango1.0-dev libasound2-dev libxpm-dev libmpd-dev cabal-install

sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list

wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg >/dev/null

echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/docker-archive-keyring.gpg

sudo add-apt-repository \ "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

sudo apt install -y ttf-mscorefonts-installer fontconfig libfontconfig1-dev qml-module-qtquick-controls qml-module-qtquick-controls2 libxrandr-dev libxss-dev pkgconf libxft-dev adwaita-icon-theme arandr automake autorandr bat bzip2 exa feh flameshot flatpak fzf git keepassxc linux-headers-$(uname -r) lxappearance lxqt-policykit p7zip p7zip-full pavucontrol pdftk tcl tk8.6 picom qemu-utils qemu-system-x86 qemu-system-gui r-base ranger rsync virt-manager vlc transmission-gtk zathura zathura-cb zathura-djvu zathura-pdf-poppler zathura-ps zsh zplug nemo nemo-fileroller meld dconf-editor gnome-sushi python3-tk imagemagick libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev suckless-tools gnome-software-plugin-flatpak build-essential libcurl4-openssl-dev libsqlite3-dev git curl libnotify-dev libcurl4-openssl-dev haskell-stack libpango1.0-0 fonts-liberation libu2f-udev numlockx libx11-dev libxinerama-dev tldr jupyter docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-compose yasm libtool libc6 libc6-dev libnuma1 libnuma-dev libx265-dev nasm libx264-dev libvpx-dev libfdk-aac-dev libopus-dev libaom-dev libass-dev libmp3lame-dev libvorbis-dev libvpx-dev lua5.4 libcairo2-dev libpango1.0-dev texlive texlive-base texlive-bibtex-extra texlive-binaries texlive-extra-utils texlive-fonts-extra texlive-fonts-recommended texlive-font-utils texlive-formats-extra texlive-lang-portuguese texlive-latex-base texlive-latex-extra texlive-latex-recommended texlive-luatex texlive-pictures texlive-plain-generic texlive-pstricks texlive-science texlive-xetex latexmk gparted libclang-dev brave-browser sublime-text docker trayer ldc aptitude python3-nautilus imagemagick nautilus-image-converter flex bison libfreetype6-dev libxcb-xfixes0-dev libxkbcommon-dev ffmpeg libxcb-xtest0 libegl1-mesa libgl1-mesa-glx libxcb-cursor0 plasma-discover-backend-flatpak ffmpegthumbnailer unar jq poppler-utils fd-find zoxide ripgrep luarocks xclip tmux stow xmonad xmobar yad suckless-tools

git clone https://github.com/neovim/neovim

cd neovim/

git checkout stable

make CMAKE_BUILD_TYPE=RelWithDebInfo

sudo make install

cd ~

rm -rf neovim

curl -fsS https://dlang.org/install.sh | bash -s dmd

DLANG=$(/usr/bin/ls ~/dlang/ | grep dmd | awk '{print $1}')

source ~/dlang/$DLANG/activate

git clone https://github.com/abraunegg/onedrive.git

cd onedrive

./configure

make clean

make

sudo make install

deactivate

cd ~

rm -rf dlang

rm -rf onedrive

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

source "$HOME/.cargo/env"

rustup update

git clone https://github.com/sxyazi/yazi.git

cd yazi

cargo build --release --locked

sudo mv target/release/yazi target/release/ya /usr/local/bin/

cd ~

rm -rf yazi

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

curl -sS https://getcomposer.org/installer -o composer-setup.php

sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer

curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin

ln -sf ~/.local/kitty.app/bin/kitty ~/.local/kitty.app/bin/kitten ~/.bin/

cp ~/.local/kitty.app/share/applications/kitty.desktop ~/.local/share/applications/

cp ~/.local/kitty.app/share/applications/kitty-open.desktop ~/.local/share/applications/

sed -i "s|Icon=kitty|Icon=$(readlink -f ~)/.local/kitty.app/share/icons/hicolor/256x256/apps/kitty.png|g" ~/.local/share/applications/kitty*.desktop

sed -i "s|Exec=kitty|Exec=$(readlink -f ~)/.local/kitty.app/bin/kitty|g" ~/.local/share/applications/kitty*.desktop

echo 'kitty.desktop' >~/.config/xdg-terminals.list

sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

cd ~/.config/

rm -r autostart

# rm -rf keepassxc

# ln -s ~/GitHub/dot/Debian/config/keepassxc/ ./

rm -r gtk-3.0

cd ~/GitHub/dot/Debian/stow_configs/

stow -t /home/jfreitas/ *

cd .local/share/fonts/

fc-cache -f -v

cd ~

curl https://pyenv.run | bash

curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh

curl -sS https://starship.rs/install.sh | sh

sudo apt remove gnome-games gnome-contacts gnome-weather gnome-maps gnome-music rhythmbox gnome-characters gnome-clocks cups cups-common apache2-bin gnome-user-share libapache2-mod-dnssd --purge

sudo apt autoremove

sudo rm /etc/default/grub

sudo ln -s ~/GitHub/dot/Debian/grub/grub /etc/default/grub

sudo update-grub2

sudo rm -rf /etc/libvirt

sudo ln -s ~/GitHub/dot/Debian/libvirt /etc/libvirt

sudo systemctl enable fstrim.timer

sudo systemctl enable libvirtd

sudo systemctl enable docker

sudo usermod -aG libvirt jfreitas

sudo usermod -aG docker jfreitas

sudo timedatectl set-local-rtc 1

sudo chsh -s /bin/zsh jfreitas