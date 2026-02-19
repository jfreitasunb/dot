#!/bin/bash

cd ~

sudo apt install curl ninja-build gettext cmake unzip build-essential python3-pip git python3-apt python3-debian pandoc wget unzip libffi-dev libgmp-dev libx11-dev libxrandr-dev libxinerama-dev libxss-dev pkg-config libxft-dev xorg-dev libxrandr-dev libpango1.0-dev libasound2-dev libxpm-dev libmpd-dev cabal-install meson libwayland-dev wayland-protocols scdoc

sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list

wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg >/dev/null

echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

curl -fsSL https://apt.fury.io/wez/gpg.key | sudo gpg --yes --dearmor -o /etc/apt/keyrings/wezterm-fury.gpg

echo 'deb [signed-by=/etc/apt/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' | sudo tee /etc/apt/sources.list.d/wezterm.list

sudo apt modernize-sources

sudo apt update

sudo apt install ttf-mscorefonts-installer fontconfig libfontconfig1-dev qml-module-qtquick-controls qml-module-qtquick-controls2 libxrandr-dev libxss-dev pkgconf libxft-dev adwaita-icon-theme arandr automake autorandr bat bzip2 eza feh flameshot flatpak fzf git keepass2 lxappearance p7zip p7zip-full pavucontrol pdftk picom qemu-utils qemu-system-x86 qemu-system-gui r-base ranger rsync virt-manager vlc transmission-gtk zathura zathura-cb zathura-djvu zathura-pdf-poppler zathura-ps zsh zplug nemo nemo-fileroller meld dconf-editor gnome-sushi python3-tk imagemagick libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev libncursesw5-dev xz-utils libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev gnome-software-plugin-flatpak build-essential libcurl4-openssl-dev libsqlite3-dev libnotify-dev libcurl4-openssl-dev haskell-stack fonts-liberation numlockx libx11-dev libxinerama-dev yasm libtool libc6 libc6-dev libnuma1 libnuma-dev libx265-dev nasm libx264-dev libvpx-dev libfdk-aac-dev libopus-dev libaom-dev libass-dev libmp3lame-dev libvorbis-dev libvpx-dev lua5.4 libcairo2-dev libpango1.0-dev texlive texlive-base texlive-bibtex-extra texlive-binaries texlive-extra-utils texlive-fonts-extra texlive-fonts-recommended texlive-font-utils texlive-formats-extra texlive-lang-portuguese texlive-latex-base texlive-latex-extra texlive-latex-recommended texlive-luatex texlive-pictures texlive-plain-generic texlive-pstricks texlive-science texlive-xetex latexmk gparted libclang-dev brave-browser sublime-text ldc python3-nautilus imagemagick flex bison libfreetype6-dev libxcb-xfixes0-dev libxkbcommon-dev ffmpeg libxcb-xtest0 libxcb-cursor0 ffmpegthumbnailer unar jq poppler-utils fd-find zoxide ripgrep luarocks xclip tmux stow xmonad xmobar yad suckless-tools volumeicon-alsa blueman pcmanfm htop fprintd libpam-fprintd tk-dev sway wofi waybar swaylock wlogout libdbus-1-dev python3-pip python3-venv python3-v-sim python-dbus-dev libpangocairo-1.0-0 python3-cairocffi python3-xcffib libxkbcommon-dev libxkbcommon-x11-dev sxhkd bc libfont-freetype-perl autoconf gcc make pkg-config libpam0g-dev libcairo2-dev libfontconfig1-dev libxcb-composite0-dev libev-dev libx11-xcb-dev libxcb-xkb-dev libxcb-xinerama0-dev libxcb-randr0-dev libxcb-image0-dev libxcb-util0-dev libxcb-xrm-dev libxkbcommon-dev libxkbcommon-x11-dev libjpeg-dev libgif-dev virtiofsd swayidle gnome-shell-extensions network-manager-applet copyq clang pulseaudio-utils nodejs npm latex-cjk-all ddcutil gawk wezterm kitty wl-clipboard cliphist dunst freerdp3-x11 fd-find chafa resvg 7zip-standalone ueberzug hyprland hyprland-protocols hyprpicker hyprland-qtutils hyprcursor-util hyprpaper hypridle neovim onedrive hyprlock

#sudo apt install -t bookworm-backports -y curl libcurl4

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

#curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

#source "$HOME/.cargo/env"

#rustup update

#git clone https://github.com/sxyazi/yazi.git

#cd yazi

#cargo build --release --locked

#sudo mv target/release/yazi target/release/ya /usr/local/bin/

#cd ~

#rm -rf yazi

git clone https://github.com/Raymo111/i3lock-color.git

cd i3lock-color

./install-i3lock-color.sh

cd ~

rm -rf i3lock-color

wget https://raw.githubusercontent.com/betterlockscreen/betterlockscreen/main/install.sh -O - -q | sudo bash -s system

cd ~

git clone https://github.com/mortie/swaylock-effects.git

cd swaylock-effects/

meson build

ninja -C build

sudo ninja -C build install

cd ~

rm -rf swaylock-effects

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install flathub com.bitwarden.desktop

flatpak install flathub org.gimp.GIMP

flatpak install flathub io.github.shiftey.Desktop

flatpak install flathub com.github.PintaProject.Pinta

flatpak install flathub com.spotify.Client

flatpak install flathub org.texstudio.TeXstudio

flatpak install flathub com.github.xournalpp.xournalpp

flatpak install flathub org.geogebra.GeoGebra

rm -rf ~/.config

rm -rf ~/.local/share/gnome-shell

cd ~/GitHub/dot/rivendel/stow_configs/

stow -t /home/jfreitas/ *

cd ~/.local/share/fonts/

fc-cache -f -v

cd ~

#curl https://pyenv.run | bash

curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh

curl -sS https://starship.rs/install.sh | sh

sudo apt remove gnome-games gnome-contacts gnome-weather gnome-maps gnome-music rhythmbox gnome-characters gnome-clocks cups cups-common apache2-bin gnome-user-share libapache2-mod-dnssd php-cli php-mbstring --purge

sudo apt autoremove

sudo rm /etc/default/grub

sudo ln -s ~/GitHub/dot/rivendel/grub/grub /etc/default/grub

sudo update-grub2

sudo rm -rf /etc/systemd/sleep.conf

sudo rm -rf /etc/systemd/logind.conf

sudo ln -s ~/GitHub/dot/rivendel/logind/sleep.conf /etc/systemd/sleep.conf

sudo ln -s ~/GitHub/dot/rivendel/logind/logind.conf /etc/systemd/logind.conf

sudo rm -rf /etc/libvirt/qemu

sudo rm -rf /etc/libvirt/qemu.conf

sudo rm -rf /etc/libvirt/storage

sudo ln -s ~/GitHub/dot/rivendel/maquinas_virtuais/qemu /etc/libvirt/

sudo ln -s ~/GitHub/dot/rivendel/maquinas_virtuais/storage /etc/libvirt/

sudo ln -s /home/jfreitas/GitHub/dot/rivendel/maquinas_virtuais/qemu.conf /etc/libvirt/

sudo systemctl enable fstrim.timer

sudo systemctl enable libvirtd

sudo usermod -aG libvirt jfreitas

sudo chsh -s $(which zsh) jfreitas

sudo ln -s /usr/lib/systemd/system/systemd-suspend-then-hibernate.service /etc/systemd/system/systemd-suspend.service

python3 -m venv ~/.local/src/venv/

cd ~/.local/src/venv/bin/

./pip install stacki3

cd ~

echo 'NotShowIn=GNOME;' | sudo tee -a /etc/xdg/autostart/blueman.desktop

sudo systemctl disable ModemManager.service

sudo systemctl disable avahi-daemon.service

sudo systemctl disable avahi-daemon.socket

sudo timedatectl set-local-rtc 1
