#!/bin/bash

cd ~/

git clone https://aur.archlinux.org/paru.git

cd paru/

makepkg -si --noconfirm

cd ..

rm -rf paru

paru -S burpsuite candy-icons-git picom siji-git ttf-meslo ttf-ms-fonts ttf-unifont auto-cpufreq otf-font-awesome-5 ttf-material-design-icons-git brave-bin zplug

curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg

echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf

sudo pacman -Syy

sleep 5

sudo pacman -S --needed firefox nitrogen lxappearance dmenu arandr arc-gtk-theme arc-icon-theme vlc \
  ttf-bitstream-vera ttf-croscore ttf-dejavu ttf-droid gnu-free-fonts ttf-ibm-plex ttf-liberation ttf-linux-libertine noto-fonts \
  ttf-roboto tex-gyre-fonts ttf-ubuntu-font-family ttf-anonymous-pro ttf-cascadia-code ttf-fantasque-sans-mono ttf-hack ttf-inconsolata \
  ttf-jetbrains-mono ttf-monofur adobe-source-code-pro-fonts cantarell-fonts inter-font ttf-opensans gentium-plus-font \
  adobe-source-han-sans-otc-fonts adobe-source-han-serif-otc-fonts noto-fonts-cjk noto-fonts-emoji rofi playerctl \
  scrot dunst pacman-contrib cuda composer file-roller filezilla htop imagemagick img2pdf mousetweaks nodejs npm php \
  numlockx pinta qalculate-gtk trayer vim-spell-pt volumeicon wget xdotool xmobar xmonad xmonad-contrib xournalpp vifm \
  xorg-xinit pcmanfm keychain alacritty autorandr ranger ripgrep the_silver_searcher \
  ttf-liberation usbutils wmctrl xorg-xauth xorg-xmodmap xorg-xrdb vlc sublime-text nasm


#cd /tmp

#wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz

#zcat install-tl-unx.tar.gz | tar xf -

#cd install-tl-*/

#sudo perl ./install-tl

#git clone https://github.com/neovim/neovim

#cd neovim/

#git checkout stable

#make CMAKE_BUILD_TYPE=RelWithDebInfo

#sudo make install

#cd ~

#rm -rf neovim

flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

mkdir ~/nvidia/ && cd ~/nvidia/

git clone https://git.videolan.org/git/ffmpeg/nv-codec-headers.git

cd nv-codec-headers

git checkout 4026cb02a6fee06068e45ce296e2f2fa947688d9

sudo make install

cd ~/nvidia/

git clone https://git.ffmpeg.org/ffmpeg.git ffmpeg/

cd ~/nvidia/ffmpeg/

#./configure --enable-nonfree --enable-cuda-nvcc --enable-libnpp --extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64 --disable-static --enable-shared

./configure --enable-nonfree --enable-cuda-nvcc --extra-cflags=-I/usr/local/cuda/include --extra-ldflags=-L/usr/local/cuda/lib64 --enable-gpl \
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

cd ~

rm -rf nvidia

cd ~/.config/

ln -s ~/GitHub/dot/Manjaro/config/alacritty ./

ln -s ~/GitHub/dot/Manjaro/config/aliases/ ./

ln -s ~/GitHub/dot/Manjaro/config/autorandr/ ./

ln -s ~/GitHub/dot/Manjaro/config/nvim/ ./

ln -s ~/GitHub/dot/Manjaro/config/picom/ ./

ln -s ~/GitHub/dot/Manjaro/config/terminator/ ./

ln -s ~/GitHub/dot/Manjaro/config/xmonad/ ./

ln -s ~/GitHub/dot/Manjaro/config/xmobar/ ./

ln -s ~/GitHub/dot/Manjaro/config/zathura/ ./

ln -s ~/GitHub/dot/Manjaro/config/zsh/ ./

ln -s ~/GitHub/dot/Manjaro/config/keepassxc/ ./

ln -s ~/GitHub/dot/Manjaro/config/nemo/ ./

ln -s ~/GitHub/dot/Manjaro/config/gtk-3.0 ./

ln -s ~/GitHub/dot/Manjaro/config/autostart ./

ln -s ~/GitHub/dot/Manjaro/config/systemd ./

mkdir texstudio

cd texstudio

ln -s ~/GitHub/dot/Manjaro/config/texstudio/texstudio.ini ./

cd ~

ln -s ~/GitHub/dot/Manjaro/bin/ ./.local/bin

cd .local/share/

ln -s ~/GitHub/dot/Manjaro/fonts/ ./

fc-cache -f -v

cd ~

ln -s GitHub/dot/Gondor/config/latexmkrc ./.latexmkrc

ln -s GitHub/dot/Manjaro/config/Xmodmap ./.Xmodmap

sudo ln -s ~/GitHub/dot/Manjaro/hooks /etc/pacman.d/

sudo cp ~/GitHub/dot/Manjaro/config/systemd/gondor_root.service /etc/systemd/system/

sudo cp ~/GitHub/dot/Manjaro/config/systemd/gondor_root.timer /etc/systemd/system/

sudo systemctl enable gondor_root.timer

sudo systemctl enable gondor_root.service

printf "\e[1;32mCHANGE NECESSARY FILES BEFORE REBOOT\e[0m"