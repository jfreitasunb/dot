#!/bin/bash
cd ~

sudo nala install -y curl ninja-build gettext cmake unzip build-essential python3-pip git python3-apt python3-debian pandoc wget

sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null

echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/docker-archive-keyring.gpg

sudo add-apt-repository \ "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

sudo nala install -y fontconfig libfontconfig1-dev qml-module-qtquick-controls qml-module-qtquick-controls2 libxrandr-dev libxss-dev pkgconf libxft-dev adwaita-icon-theme arandr automake autorandr bat bzip2 exa feh flameshot flatpak fzf git keepassxc linux-headers-$(uname -r) lxappearance lxqt-policykit nvidia-driver nvidia-cuda-dev nvidia-cuda-gdb nvidia-cuda-toolkit p7zip p7zip-full pavucontrol pdftk tcl tk8.6 picom qemu-utils qemu-system-x86 qemu-system-gui r-base ranger rsync sddm virt-manager vlc transmission-gtk zathura zathura-cb zathura-djvu zathura-pdf-poppler zathura-ps zsh zplug nemo nemo-fileroller meld dconf-editor gnome-sushi python3-tk imagemagick libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev suckless-tools gnome-software-plugin-flatpak build-essential libcurl4-openssl-dev libsqlite3-dev git curl libnotify-dev libcurl4-openssl-dev haskell-stack libpango1.0-0 fonts-liberation libu2f-udev numlockx nodejs npm libx11-dev libxinerama-dev texstudio tldr jupyter docker-ce docker-ce-cli containerd.io docker-compose-plugin yasm libtool libc6 libc6-dev libnuma1 libnuma-dev libx265-dev nasm libx264-dev libvpx-dev libfdk-aac-dev libopus-dev libaom-dev libass-dev libmp3lame-dev libvorbis-dev libvpx-dev lua5.4 libcairo2-dev libpango1.0-dev

git clone https://github.com/neovim/neovim

cd neovim/

git checkout stable

make CMAKE_BUILD_TYPE=RelWithDebInfo

sudo make install

cd ~

rm -rf neovim

sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

sudo curl https://sh.rustup.rs -sSf | sh

source ~/.cargo/env

git clone -b v0.12.2 https://github.com/jwilm/alacritty.git

cd alacritty/

cargo build --release

sudo tic -xe alacritty,alacritty-direct extra/alacritty.info

infocmp alacritty

sudo cp target/release/alacritty /usr/local/bin

sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg

sudo desktop-file-install extra/linux/Alacritty.desktop

sudo update-desktop-database

cd ~

sudo rm -rf alacritty

git clone https://github.com/totoro-ghost/sddm-astronaut.git ~/astronaut/

cd astronaut/

rm -rf .git/

cd ..

sudo mv astronaut/ /usr/share/sddm/themes/

sudo rm -rf astronaut

cd .config/

ln -s ~/GitHub/dot/Debian/config/alacritty ./

ln -s ~/GitHub/dot/Debian/config/aliases/ ./

ln -s ~/GitHub/dot/Debian/config/autorandr/ ./

ln -s ~/GitHub/dot/Debian/config/nvim/ ./

ln -s ~/GitHub/dot/Debian/config/picom/ ./

ln -s ~/GitHub/dot/Debian/config/terminator/ ./

ln -s ~/GitHub/dot/Debian/config/xmonad/ ./

ln -s ~/GitHub/dot/Debian/config/xmobar/ ./

ln -s ~/GitHub/dot/Debian/config/zathura/ ./

ln -s ~/GitHub/dot/Debian/config/zsh/ ./

ln -s ~/GitHub/dot/Debian/config/keepassxc/ ./

ln -s ~/GitHub/dot/Debian/config/gtk-3.0 ./

mkdir texstudio

cd texstudio

ln -s ~/GitHub/dot/Debian/config/texstudio/texstudio.ini ./

cd ~

ln -s ~/GitHub/dot/Debian/bin/ ./.local/bin

cd .local/share/

ln -s ~/GitHub/dot/Debian/fonts/ ./

fc-cache -f -v

ln -s GitHub/dot/Gondor/config/latexmkrc ./.latexmkrc

ln -s GitHub/dot/Debian/config/Xmodmap ./.Xmodmap

sudo usermod -aG libvirt jfreitas

mkdir ~/nvidia/ && cd ~/nvidia/

git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git

cd nv-codec-headers

git checkout 4026cb02a6fee06068e45ce296e2f2fa947688d9

sudo make install

cd ~/nvidia/

git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg/

cd ~/nvidia/ffmpeg/

#./configure --enable-nonfree --enable-cuda-nvcc --enable-libnpp --extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64 --disable-static --enable-shared

./configure --enable-nonfree --enable-cuda-nvcc --enable-libnpp --extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64 --enable-gpl \
--enable-gnutls \
--enable-libaom \
--enable-libass \
--enable-libfdk-aac \
--enable-libfreetype \
--enable-libmp3lame \
--enable-libopus \
--enable-libvorbis \
--enable-libvpx \
--enable-libx264 \
--enable-libx265 \
--enable-nonfree

make -j $(nproc)

sudo make install

sudo nala remove gnome-games gnome-contacts gnome-weather gnome-maps gnome-music rhythmbox gnome-characters gnome-clocks tex-common --purge

sudo nala autoremove

sudo systemctl enable docker

cd /tmp

wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz

zcat install-tl-unx.tar.gz | tar xf -

cd install-tl-*/

sudo perl ./install-tl --gui

