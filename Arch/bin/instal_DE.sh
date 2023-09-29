#!/bin/bash

cd ~/

git clone https://aur.archlinux.org/paru.git

cd paru/

makepkg -si --noconfirm

cd ..

rm -rf paru

paru -S burpsuite candy-icons-git picom siji-git ttf-meslo ttf-ms-fonts ttf-unifont auto-cpufreq otf-font-awesome-5 ttf-material-design-icons-git brave-bin

curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg

echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf

sudo pacman -Syy

sleep 5

sudo pacman -S --needed xorg firefox nitrogen lxappearance dmenu arandr arc-gtk-theme arc-icon-theme vlc \
  ttf-bitstream-vera ttf-croscore ttf-dejavu ttf-droid gnu-free-fonts ttf-ibm-plex ttf-liberation ttf-linux-libertine noto-fonts \
  ttf-roboto tex-gyre-fonts ttf-ubuntu-font-family ttf-anonymous-pro ttf-cascadia-code ttf-fantasque-sans-mono ttf-hack ttf-inconsolata \
  ttf-jetbrains-mono ttf-monofur adobe-source-code-pro-fonts cantarell-fonts inter-font ttf-opensans gentium-plus-font \
  adobe-source-han-sans-otc-fonts adobe-source-han-serif-otc-fonts noto-fonts-cjk noto-fonts-emoji archlinux-wallpaper rofi playerctl \
  scrot dunst pacman-contrib cuda composer file-roller filezilla htop imagemagick img2pdf mousetweaks nodejs npm php \
  numlockx pinta qalculate-gtk trayer vim-spell-pt volumeicon wget xdotool xmobar xmonad xmonad-contrib xournalpp youtube-dl vifm \
  xorg-xinit pcmanfm keychain alacritty autorandr nvidia-dkms ranger ripgrep the_silver_searcher \
  ttf-liberation usbutils wmctrl xorg-xauth xorg-xmodmap xorg-xrdb


#cd /tmp

#wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz

#zcat install-tl-unx.tar.gz | tar xf -

#cd install-tl-*/

#sudo perl ./install-tl

# sudo systemctl enable lightdm

printf "\e[1;32mCHANGE NECESSARY FILES BEFORE REBOOT\e[0m"
