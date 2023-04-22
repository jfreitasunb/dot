sudo nala install -y curl ninja-build gettext cmake unzip build-essential python3-pip git python3-apt python3-debian pandoc

cd ~

git clone https://gitlab.com/volian/nala.git

cd nala/

sudo make install

cd ~

sudo rm -rf nala

sudo nala install -y fontconfig libfontconfig1-dev qml-module-qtquick-controls qml-module-qtquick-controls2 libxrandr-dev libxss-dev pkgconf libxft-dev adapta-gtk-theme adwaita-icon-theme arandr automake autorandr bat bzip2 exa feh flameshot flatpak fzf git keepassxc syncthing linux-headers-$(uname -r) lxappearance lxqt-policykit nvidia-driver nvidia-cuda-dev nvidia-cuda-gdb nvidia-cuda-toolkit p7zip p7zip-full pavucontrol pdftk tcl tk8.6 picom qemu qemu-system-common qemu-system-data qemu-system-gui qemu-utils r-base ranger rsync sddm virt-manager vlc transmission-gtk zathura zathura-cb zathura-djvu zathura-pdf-poppler zathura-ps zsh zplug nemo nemo-fileroller meld dconf-editor gnome-sushi python3-tk imagemagick libssl-dev zlib1g-dev libbz2-dev libreadline-dev libsqlite3-dev curl libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev suckless-tools gnome-software-plugin-flatpak build-essential libcurl4-openssl-dev libsqlite3-dev git curl libnotify-dev libcurl4-openssl-dev haskell-stack libpango1.0-0 fonts-liberation libu2f-udev numlockx

git clone https://github.com/neovim/neovim

cd neovim/

git checkout stable

make CMAKE_BUILD_TYPE=RelWithDebInfo

sudo make install

sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

cd ~

rm -rf neovim

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

rm -rf alacritty

git clone https://github.com/totoro-ghost/sddm-astronaut.git ~/astronaut/

cd astronaut/

rm -rf .git/

cd ..

sudo mv astronaut/ /usr/share/sddm/themes/

curl -fsS https://dlang.org/install.sh | bash -s dmd

source ~/dlang/dmd-2.102.2/activate

git clone https://github.com/abraunegg/onedrive.git

cd onedrive

./configure --enable-notifications

make clean; make;

sudo make install

deactivate

cd ..

rm -rf onedrive

systemctl --user enable syncthing.service --now

systemctl --user status onedrive.service 

cd .config/

ln -s ~/GitHub/dot/Debian/config/alacritty ./

ln -s ~/GitHub/dot/Debian/config/nvim/ ./

ln -s ~/GitHub/dot/Debian/config/xmonad/ ./

ln -s ~/GitHub/dot/Debian/config/xmobar/ ./

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
Type=Application
Encoding=UTF-8
Name=Xmonad
Exec=xmonad
NoDisplay=true
X-GNOME-WMName=Xmonad
X-GNOME-Autostart-Phase=WindowManager
X-GNOME-Provides=windowmanager
X-GNOME-Autostart-Notify=false" >> /usr/share/xsessions/xmonad.desktop

cd ~/.config/

ln -s ~/GitHub/dot/Debian/config/zsh/ ./

cd

rm .zshenv

ln -s GitHub/dot/Debian/config/zsh/zshenv ./.zshenv

cd /tmp

wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz

zcat install-tl-unx.tar.gz | tar xf -

cd install-tl-*/

sudo perl ./install-tl --gui
