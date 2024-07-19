#!/bin/bash
cd ~

sudo apt install nala

sudo nala install -y curl ninja-build gettext cmake unzip build-essential python3-pip git python3-apt python3-debian pandoc wget

sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null

echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /etc/apt/trusted.gpg.d/docker-archive-keyring.gpg

sudo add-apt-repository \ "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"

sudo nala install -y ttf-mscorefonts-installer fontconfig libfontconfig1-dev qml-module-qtquick-controls qml-module-qtquick-controls2 libxrandr-dev libxss-dev pkgconf libxft-dev adwaita-icon-theme arandr automake autorandr bat bzip2 exa feh flameshot flatpak fzf git keepassxc linux-headers-$(uname -r) lxappearance lxqt-policykit nvidia-driver nvidia-cuda-dev nvidia-cuda-gdb nvidia-cuda-toolkit p7zip p7zip-full pavucontrol pdftk tcl tk8.6 picom qemu-utils qemu-system-x86 qemu-system-gui r-base ranger rsync virt-manager vlc transmission-gtk zathura zathura-cb zathura-djvu zathura-pdf-poppler zathura-ps zsh zplug nemo nemo-fileroller meld dconf-editor gnome-sushi python3-tk imagemagick libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev suckless-tools gnome-software-plugin-flatpak build-essential libcurl4-openssl-dev libsqlite3-dev git curl libnotify-dev libcurl4-openssl-dev haskell-stack libpango1.0-0 fonts-liberation libu2f-udev numlockx libx11-dev libxinerama-dev texstudio tldr jupyter docker-ce docker-ce-cli containerd.io docker-compose-plugin yasm libtool libc6 libc6-dev libnuma1 libnuma-dev libx265-dev nasm libx264-dev libvpx-dev libfdk-aac-dev libopus-dev libaom-dev libass-dev libmp3lame-dev libvorbis-dev libvpx-dev lua5.4 libcairo2-dev libpango1.0-dev texlive texlive-base texlive-bibtex-extra texlive-binaries texlive-extra-utils texlive-fonts-extra texlive-fonts-recommended texlive-font-utils texlive-formats-extra texlive-lang-portuguese texlive-latex-base texlive-latex-extra texlive-latex-recommended texlive-luatex texlive-pictures texlive-plain-generic texlive-pstricks texlive-science texlive-xetex latexmk alacritty gparted libclang-dev brave-browser sublime-text docker xmonad xmobar libghc-xmonad-contrib-prof libghc-xmonad-extras-prof libghc-xmonad-wallpaper-prof trayer

git clone https://github.com/neovim/neovim

cd neovim/

git checkout stable

make CMAKE_BUILD_TYPE=RelWithDebInfo

sudo make install

cd ~

rm -rf neovim

sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

cd ~/.config/

ln -s ~/GitHub/dot/Debian/config/alacritty ./

ln -s ~/GitHub/dot/Debian/config/autostart ./

ln -s ~/GitHub/dot/Debian/config/aliases/ ./

ln -s ~/GitHub/dot/Debian/config/autorandr/ ./

ln -s ~/GitHub/dot/Debian/config/astronvim-jfreitas ./nvim

ln -s ~/GitHub/dot/Debian/config/picom/ ./

ln -s ~/GitHub/dot/Debian/config/xmonad/ ./

ln -s ~/GitHub/dot/Debian/config/xmobar/ ./

ln -s ~/GitHub/dot/Debian/config/zathura/ ./

ln -s ~/GitHub/dot/Debian/config/zsh/ ./

rm -rf keepassxc

ln -s ~/GitHub/dot/Debian/config/keepassxc/ ./

rm -rf gtk-3.0

ln -s ~/GitHub/dot/Debian/config/gtk-3.0 ./

mkdir texstudio

cd texstudio

ln -s ~/GitHub/dot/Debian/config/texstudio/texstudio.ini ./

cd ~

ln -s ~/GitHub/dot/Debian/config/zsh/zshrc ./.zshrc

ln -s ~/GitHub/dot/Debian/bin/ ./.bin

ln -s GitHub/dot/Debian/config/latexmkrc ./.latexmkrc

ln -s GitHub/dot/Debian/config/Xmodmap ./.Xmodmap

cd .local/share/

ln -s ~/GitHub/dot/fonts/ ./

fc-cache -f -v

cd ~/.local/share/gnome-shell

ln -s ~/GitHub/dot/Debian/gnome_extensions/extensions ./extensions

cd ~

sudo nala remove gnome-games gnome-contacts gnome-weather gnome-maps gnome-music rhythmbox gnome-characters gnome-clocks --purge

sudo rm /etc/default/grub

sudo ln -s ~/GitHub/dot/Debian/grub/grub /etc/default/grub

sudo update-grub2

sudo rm -rf /etc/libvirt

sudo ln -s ~/GitHub/dot/Debian/libvirt /etc/libvirt

sudo cp ~/GitHub/dot/Debian/config/systemd/gondor_root.service /etc/systemd/system/

sudo cp ~/GitHub/dot/Debian/config/systemd/gondor_root.timer /etc/systemd/system/

sudo systemctl enable gondor_root.timer

sudo systemctl enable gondor_root.service

sudo systemctl enable fstrim.timer

sudo systemctl enable libvirtd

sudo systemctl enable docker

sudo usermod -aG libvirt jfreitas

sudo usermod -aG docker jfreitas

sudo timedatectl set-local-rtc 1

sudo chsh -s /bin/zsh jfreitas
