sudo nala install -y curl ninja-build gettext cmake unzip build-essential python3-pip git python3-apt python3-debian pandoc

sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

sudo curl -o /usr/share/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg

echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable" | sudo tee /etc/apt/sources.list.d/syncthing.list

wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null

echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

cd ~

git clone https://gitlab.com/volian/nala.git

cd nala/

sudo make install

cd ~

sudo rm -rf nala

sudo nala install -y fontconfig libfontconfig1-dev qml-module-qtquick-controls qml-module-qtquick-controls2 libxrandr-dev libxss-dev pkgconf libxft-dev adapta-gtk-theme adwaita-icon-theme arandr automake autorandr bat bzip2 exa feh flameshot flatpak fzf git keepassxc syncthing linux-headers-$(uname -r) lxappearance lxqt-policykit nvidia-driver nvidia-cuda-dev nvidia-cuda-gdb nvidia-cuda-toolkit p7zip p7zip-full pavucontrol pdftk tcl tk8.6 picom qemu qemu-system-common qemu-system-data qemu-system-gui qemu-utils r-base ranger rsync sddm virt-manager vlc transmission-gtk zathura zathura-cb zathura-djvu zathura-pdf-poppler zathura-ps zsh zplug nemo nemo-fileroller meld dconf-editor gnome-sushi python3-tk imagemagick libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev suckless-tools gnome-software-plugin-flatpak build-essential libcurl4-openssl-dev libsqlite3-dev git curl libnotify-dev libcurl4-openssl-dev haskell-stack libpango1.0-0 fonts-liberation libu2f-udev numlockx install nodejs npm

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

git clone https://github.com/jwilm/alacritty.git

cd alacritty/

cargo build --release

sudo tic -xe alacritty,alacritty-direct extra/alacritty.info

infocmp alacritty

sudo tic -xe alacritty,alacritty-direct extra/alacritty.info

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

curl -fsS https://dlang.org/install.sh | bash -s dmd

source $(echo ~/dlang/*/)/activate

git clone https://github.com/abraunegg/onedrive.git

cd onedrive

./configure --enable-notifications

make clean; make;

sudo make install

deactivate

cd ..

sudo rm -rf onedrive

systemctl --user enable syncthing.service --now

systemctl --user enable onedrive.service 

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

cd ../

ln -s ~/GitHub/dot/Debian/bin/ ./.bin

cd .local/share/

ln -s ~/GitHub/dot/Debian/fonts/ ./

fc-cache -f -v

cd ~/.config/xmonad

git clone https://github.com/xmonad/xmonad

git clone https://github.com/xmonad/xmonad-contrib

stack upgrade

stack init

stack install

sudo ln -s ~/.local/bin/xmonad /usr/bin

sudo echo "[Desktop Entry]
Name=XMonad
Comment=Lightweight tiling window manager
Exec=xmonad
Icon=xmonad.png
Type=XSession" | sudo tee /usr/share/xsessions/xmonad.desktop

cd ~

rm .zshenv

ln -s GitHub/dot/Debian/config/zsh/zshenv ./.zshenv

ln -s GitHub/dot/Debian/config/R/Renviron ./.Renviron

ln -s GitHub/dot/Debian/config/R/Renviron.site ./.Renviron.site

ln -s GitHub/dot/Debian/config/R/Rhistory ./.Rhistory

ln -s GitHub/dot/Debian/config/R/Rprofile ./.Rprofile

ln -s GitHub/dot/Gondor/config/latexmkrc ./.latexmkrc

ln -s GitHub/dot/Debian/config/Xmodmap ./.Xmodmap

sudo usermod -aG libvirt jfreitas

cd /tmp

wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz

zcat install-tl-unx.tar.gz | tar xf -

cd install-tl-*/

sudo perl ./install-tl --gui
