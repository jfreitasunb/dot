!/bin/bash

cd ~

sudo pacman -S --needed git base-devel

git clone https://aur.archlinux.org/yay-bin

cd yay-bin

makepkg -si

cd ~

rm -rf yay-bin

curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg

echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf

yay -Syy

sleep 5

yay -S --needed arandr brave-bin candy-icons-git cantarell-fonts dconf-editor dropbox exa feh file-roller filezilla firefox flatpak fzf gdal gentium-plus-font gimp gimp-help-pt_br gnu-free-fonts gparted htop imagemagick img2pdf inter-font jq keepassxc keychain libreoffice-fresh libreoffice-fresh-pt-br man meld mousetweaks noto-fonts noto-fonts-cjk noto-fonts-emoji nss-mdns openbsd-netcat otf-font-awesome-5 papirus-icon-theme pavucontrol pcmanfm pdftk pinta ranger ripgrep scrot sof-firmware sublime-text terminus-font tex-gyre-fonts texlive-basic texlive-bibtexextra texlive-bin texlive-binextra texlive-context texlive-fontsextra texlive-fontsrecommended texlive-fontutils texlive-formatsextra texlive-langportuguese texlive-latex texlive-latexextra texlive-latexrecommended texlive-luatex texlive-mathscience texlive-meta texlive-metapost texlive-pictures texlive-pstricks texlive-xetex the_silver_searcher tldr unzip usbutils vifm vim-spell-pt vlc wget wmctrl xdotool xournalpp yasm zathura zathura-djvu zathura-pdf-mupdf zathura-ps zplug yazi fragments hyprland xdg-desktop-portal-hyprland waybar wofi hyprpaper hyprcursor hyprutils hyprwayland-scanner grim slurp hyprpicker xdg-desktop-portal-wlr hyprshot hyprlock hypridle fd luarocks tmux grub-theme-vimix fwupd wezterm-git lazygit wlogout starship dmd stow sbctl blueman strace trash tk cliphist biber rofi greenclip xclip copyq dunst picom dmenu xorg xmonad xmonad-contrib xmonad-extras xmonad-utils xmobar betterlockscreen onedrive-abraunegg vlc-plugins-all alacritty kitty grub-theme-vimix

git clone https://github.com/neovim/neovim

cd neovim/

git checkout stable

make CMAKE_BUILD_TYPE=RelWithDebInfo

sudo make install

cd ~

rm -rf neovim

cd ~

sudo rm /etc/systemd/sleep.conf

sudo ln -s /home/jfreitas/GitHub/dot/rivendel/logind/sleep.conf /etc/systemd/

sudo rm /etc/systemd/logind.conf

sudo ln -s /home/jfreitas/GitHub/dot/rivendel/logind/logind.conf /etc/systemd/

sudo rm /etc/mkinitcpio.conf

sudo ln -s /home/jfreitas/GitHub/dot/rivendel/mkinitcpio/mkinitcpio.conf /etc/

sudo rm /etc/pacman.conf

sudo ln -s ~/GitHub/dot/rivendel/pacman/pacman.conf /etc/

sudo rm /etc/default/grub

sudo ln -s ~/GitHub/dot/rivendel/grub/grub-ARCH /etc/default/

sudo rm -rf /etc/libvirt/qemu

sudo rm -rf /etc/libvirt/qemu.conf

sudo rm -rf /etc/libvirt/storage

sudo ln -s ~/GitHub/dot/rivendel/maquinas_virtuais/qemu /etc/libvirt/

sudo ln -s ~/GitHub/dot/rivendel/maquinas_virtuais/storage /etc/libvirt/

sudo ln -s /home/jfreitas/GitHub/dot/rivendel/maquinas_virtuais/qemu.conf /etc/libvirt/

#sudo systemctl enable docker

sudo systemctl enable --now auto-cpufreq.service

#sudo usermod -aG docker jfreitas

sudo mkinitcpio -P

sudo grub-mkconfig -o /boot/grub/grub.cfg

#sudo systemctl enable libvirtd

sudo chsh -s $(which zsh) jfreitas

#sudo chattr +C /var/log

#sudo chattr +C /var/lib/docker

#sudo chattr +C /var/lib/libvirt

#sudo chattr +C /var/lib/pacman/pkg

#sudo chattr +C /var/cache

flatpak install flathub io.github.shiftey.Desktop

flatpak install flathub com.bitwarden.desktop

flatpak install flathub com.spotify.Client

flatpak install flathub org.texstudio.TeXstudio

flatpak install flathub com.discordapp.Discord

sudo ln -s /usr/lib/systemd/system/systemd-suspend-then-hibernate.service /etc/systemd/system/systemd-suspend.service

echo 'NotShowIn=GNOME;' | sudo tee -a /etc/xdg/autostart/blueman.desktop

#sudo usermod -aG libvirt jfreitas

rm -rf ~/.config

rm -rf ~/.local/share/gnome-shell

cd ~/GitHub/dot/rivendel/stow_configs/

stow -t /home/jfreitas/ *

cd ~/.local/share/fonts/

fc-cache -f -v

cd ~

curl https://pyenv.run | bash

curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
