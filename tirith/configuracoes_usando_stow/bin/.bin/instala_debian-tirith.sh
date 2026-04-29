#!/bin/bash

cd ~

#Instala o curl, git, npm, nodejs

sudo apt install curl git nodejs npm build-essential automake python3.13-venv -y

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

sudo make install

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

sudo make install

deactivate

cd ~

rm -rf dlang

rm -rf onedrive

#Fontes

sudo apt install ttf-mscorefonts-installer fontconfig libfontconfig1-dev -y

#Pacotes de propósito geral

sudo apt install bat bzip2 eza feh flameshot flatpak fzf p7zip p7zip-full pdftk ranger rsync vlc transmission-gtk zathura zathura-cb zathura-djvu zathura-pdf-poppler zathura-ps meld imagemagick xz-utils fd-find zoxide ripgrep luarocks xclip ffmpeg ffmpegthumbnailer htop autoconf gcc make pkg-config poppler-utils -y

#R

sudo apt install lib32gcc-s1 lib32stdc++6 libc6-i386 libclang-19-dev libclang-common-19-dev libclang-dev libclang-rt-19-dev libclang1-19 libobjc-14-dev libobjc4 r-base -y

#ZSH e terminal

sudo apt install zsh alacritty kitty -y

sudo chsh -s $(which zsh) jfreitas

cd ~

git clone https://github.com/zplug/zplug ~/.local/share/zplug

#Pacotes para Gnome

sudo apt install dconf-editor gnome-sushi libnotify-dev gparted python3-nautilus gnome-shell-extensions -y

echo 'NotShowIn=GNOME;' | sudo tee -a /etc/xdg/autostart/blueman.desktop

#LaTeX

sudo apt install texlive texlive-base texlive-bibtex-extra texlive-binaries texlive-extra-utils texlive-fonts-extra texlive-fonts-recommended texlive-font-utils texlive-formats-extra texlive-lang-portuguese texlive-latex-base texlive-latex-extra texlive-latex-recommended texlive-luatex texlive-pictures texlive-plain-generic texlive-pstricks texlive-science texlive-xetex latexmk latex-cjk-all texstudio -y

#TMUX

sudo apt install tmux -y

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

#Sway

sudo apt install sway wofi waybar swaylock wlogout cliphist swayidle network-manager-applet wl-clipboard dunst blueman -y

python3 -m venv ~/.local/src/venv/

cd ~/.local/src/venv/bin/

./pip install stacki3

cd ~

#Hyprland

sudo apt install hyprland hyprland-protocols hyprpicker hyprland-qtutils hyprcursor-util hyprpaper hypridle hyprlock -y

#Xmonad

sudo apt install xmonad xmobar yad suckless-tools volumeicon-alsa pcmanfm lxappearance pavucontrol picom adwaita-icon-theme arandr autorandr nemo nemo-fileroller -y

#FSTRIM

sudo systemctl enable fstrim.timer

#Stow

sudo apt install stow -y

rm -rf ~/.config

#rm -rf ~/.local/share/gnome-shell

cd ~/GitHub/dot/tirith/configuracoes_usando_stow/

stow -t /home/jfreitas/ *

cd ~/.local/share/fonts/

fc-cache -f -v

cd ~

#Flatpaks

sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install flathub com.bitwarden.desktop -y

flatpak install flathub io.github.shiftey.Desktop -y

flatpak install flathub com.github.PintaProject.Pinta -y

flatpak install flathub com.github.xournalpp.xournalpp -y

flatpak install flathub org.geogebra.GeoGebra -y

flatpak install flathub org.keepassxc.KeePassXC -y

#Atuin, starship e uv

curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh

curl -sS https://starship.rs/install.sh | sh

curl -LsSf https://astral.sh/uv/install.sh | sh

#Removendo programas e desativando serviçoes

sudo apt remove -y gnome-games gnome-contacts gnome-weather gnome-maps gnome-music rhythmbox gnome-characters gnome-clocks cups cups-common apache2-bin gnome-user-share libapache2-mod-dnssd php-cli php-mbstring --purge

sudo apt autoremove -y

sudo systemctl disable ModemManager.service

sudo systemctl disable avahi-daemon.service

sudo systemctl disable avahi-daemon.socket
