#!/bin/bash

cd ~/

sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si

cd ..

rm -rf yay-bin

sudo curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg

echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf

yay -Syy

sleep 5

yay -S --needed candy-icons-git picom siji-git ttf-meslo ttf-ms-fonts ttf-unifont \
  auto-cpufreq otf-font-awesome-5 ttf-material-design-icons-git brave-bin zplug rstudio-desktop-bin \
  google-chrome firefox nitrogen lxappearance dmenu arandr arc-gtk-theme arc-icon-theme vlc \
  ttf-bitstream-vera ttf-croscore ttf-dejavu ttf-droid gnu-free-fonts ttf-ibm-plex ttf-liberation ttf-linux-libertine noto-fonts \
  ttf-roboto tex-gyre-fonts ttf-ubuntu-font-family ttf-anonymous-pro ttf-cascadia-code ttf-fantasque-sans-mono ttf-hack ttf-inconsolata \
  ttf-jetbrains-mono ttf-monofur adobe-source-code-pro-fonts cantarell-fonts inter-font ttf-opensans gentium-plus-font \
  adobe-source-han-sans-otc-fonts adobe-source-han-serif-otc-fonts noto-fonts-cjk noto-fonts-emoji rofi playerctl \
  scrot dunst pacman-contrib composer file-roller filezilla htop imagemagick img2pdf mousetweaks nodejs npm php \
  numlockx pinta qalculate-gtk trayer vim-spell-pt volumeicon wget xdotool xmobar xmonad xmonad-contrib xournalpp vifm \
  xorg-xinit pcmanfm keychain kitty autorandr ranger ripgrep the_silver_searcher \
  ttf-liberation usbutils wmctrl xorg-xauth xorg-xmodmap xorg-xrdb vlc sublime-text nasm \
  inetutils dnsutils bash-completion openssh tlp edk2-ovmf bridge-utils dnsmasq vde2 openbsd-netcat ebtables ipset nss-mdns terminus-font \
  awesome-terminal-fonts bat exa bpytop meld neofetch ttf-fira-code ttf-fira-mono ttf-font-awesome zathura zathura-djvu \
  zathura-pdf-mupdf zathura-ps gimp gimp-help-pt_br keepassxc p7zip papirus-icon-theme pdftk python-beautifulsoup4 python-pip terminator \
  pavucontrol xorg-xinit fzf less flatpak cmake unzip ninja curl docker-compose yasm nemo nemo-fileroller nemo-preview \
  virt-manager iptables-nft libvirt qemu-full base-devel texlive-basic texlive-bibtexextra texlive-bin texlive-binextra texlive-context \
  texlive-fontsextra texlive-fontsrecommended texlive-fontutils texlive-formatsextra texlive-langportuguese texlive-latex texlive-latexextra \
  texlive-latexrecommended texlive-luatex texlive-mathscience texlive-meta texlive-metapost texlive-pictures texlive-pstricks texlive-xetex \
  texstudio tldr linux-headers gdal jq docker neovim gparted feh xorg-xsetroot dropbox onedrive-abraunegg


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

#flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

cd ~/.config/

ln -s ~/GitHub/dot/Manjaro-KDE/config/kitty ./

ln -s ~/GitHub/dot/Manjaro-KDE/config/aliases/ ./

ln -s ~/GitHub/dot/Manjaro-KDE/config/autorandr/ ./

ln -s ~/GitHub/dot/Manjaro-KDE/config/astronvim-jfreitas ./nvim

ln -s ~/GitHub/dot/Manjaro-KDE/config/picom/ ./

ln -s ~/GitHub/dot/Manjaro-KDE/config/xmonad/ ./

ln -s ~/GitHub/dot/Manjaro-KDE/config/xmobar/ ./

ln -s ~/GitHub/dot/Manjaro-KDE/config/zathura/ ./

ln -s ~/GitHub/dot/Manjaro-KDE/config/zsh/ ./

ln -s ~/GitHub/dot/Manjaro-KDE/config/keepassxc/ ./

ln -s ~/GitHub/dot/Manjaro-KDE/config/nemo/ ./

ln -s ~/GitHub/dot/Manjaro-KDE/config/gtk-3.0 ./

ln -s ~/GitHub/dot/Manjaro-KDE/config/autostart ./

ln -s ~/GitHub/dot/Manjaro-KDE/config/systemd ./

mkdir texstudio

cd texstudio

ln -s ~/GitHub/dot/Manjaro-KDE/config/texstudio/texstudio.ini ./

cd ~

ln -s ~/GitHub/dot/Manjaro-KDE/bin/ ./.bin

cd .local/share/

ln -s ~/GitHub/dot/fonts/ ./

fc-cache -f -v

cd ~

curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash

ln -s ~/GitHub/dot/Manjaro-KDE/config/latexmkrc ./.latexmkrc

ln -s ~/GitHub/dot/Manjaro-KDE/config/Xmodmap ./.Xmodmap

#ln -s ~/GitHub/dot/Manjaro-KDE/config/histdb  /.histdb

rm .zshrc

ln -s ~/GitHub/dot/Manjaro-KDE/config/zsh/zshrc ./.zshrc

sudo rm /etc/pacman.conf

sudo ln -s ~/GitHub/dot/Manjaro-KDE/pacman/pacman.conf /etc/pacman.conf

sudo rm /etc/default/grub

sudo ln -s ~/GitHub/dot/Manjaro-KDE/grub/grub /etc/default/grub

sudo rm -rf /etc/libvirt

sudo ln -s ~/GitHub/dot/Manjaro-KDE/libvirt /etc/libvirt

sudo cp ~/GitHub/dot/Manjaro-KDE/config/systemd/gondor_root.service /etc/systemd/system/

sudo cp ~/GitHub/dot/Manjaro-KDE/config/systemd/gondor_root.timer /etc/systemd/system/

sudo cp ~/GitHub/dot/Manjaro-KDE/config/systemd/manjaro_keyboard.service  /etc/systemd/system/

sudo systemctl enable gondor_root.timer

sudo systemctl enable gondor_root.service

sudo systemctl enable manjaro_keyboard.service

sudo systemctl enable sshd

sudo systemctl enable tlp

sudo systemctl enable fstrim.timer

sudo systemctl enable libvirtd

sudo systemctl enable docker

sudo usermod -aG libvirt jfreitas

sudo usermod -aG docker jfreitas

sudo timedatectl set-local-rtc 1

sudo chattr +C /var/log

sudo chattr +C /var/lib/docker

sudo chattr +C /var/lib/libvirt

printf "\e[1;32mCHANGE NECESSARY FILES BEFORE REBOOT\e[0m"
