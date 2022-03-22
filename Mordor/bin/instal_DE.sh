#!/bin/bash

git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
#sudo pacman -U <the-package-file-that-makepkg-produces>

cd ..

paru -S --noconfirm burpsuite candy-icons-git dropbox google-chrome nerd-fonts-mononoki onedrive-abraunegg picom-jonaburg-git siji-git teams ttf-meslo ttf-ms-fonts ttf-unifont nerd-fonts-iosevka otf-font-awesome-5-free polybar ttf-material-design-icons-git

sudo pacman -S --noconfirm xorg bspwm sxhkd firefox nitrogen lxappearance dmenu arandr arc-gtk-theme arc-icon-theme obs-studio vlc ttf-bitstream-vera ttf-croscore ttf-dejavu ttf-droid gnu-free-fonts ttf-ibm-plex ttf-liberation ttf-linux-libertine noto-fonts ttf-roboto tex-gyre-fonts ttf-ubuntu-font-family ttf-anonymous-pro ttf-cascadia-code ttf-fantasque-sans-mono ttf-hack ttf-inconsolata ttf-jetbrains-mono ttf-monofur adobe-source-code-pro-fonts cantarell-fonts inter-font ttf-opensans gentium-plus-font adobe-source-han-sans-otc-fonts adobe-source-han-serif-otc-fonts noto-fonts-cjk noto-fonts-emoji archlinux-wallpaper rofi playerctl scrot dunst pacman-contrib composer file-roller filezilla htop imagemagick img2pdf mousetweaks nodejs npm php numlockx pinta qalculate-gtk trayer vim-spell-pt volumeicon wget xdotool xmobar xmonad xmonad-contrib xournalpp youtube-dl vifm xorg-xinit pcmanfm keychain alacritty autorandr gitui ranger ripgrep the_silver_searcher ttf-liberation usbutils wmctrl xorg-xauth xorg-xmodmap xorg-xrdb


# sudo systemctl enable lightdm

mkdir -p .config/{bspwm,sxhkd,dunst}

install -Dm755 /usr/share/doc/bspwm/examples/bspwmrc ~/.config/bspwm/bspwmrc
install -Dm644 /usr/share/doc/bspwm/examples/sxhkdrc ~/.config/sxhkd/sxhkdrc

printf "\e[1;32mCHANGE NECESSARY FILES BEFORE REBOOT\e[0m"
