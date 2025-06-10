!/bin/bash

cd ~/

sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay-bin && cd yay-bin && makepkg -si

cd ..

rm -rf yay-bin

curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg

echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf

yay -Syy

sleep 5

yay -S --needed adobe-source-code-pro-fonts adobe-source-han-sans-otc-fonts adobe-source-han-serif-otc-fonts arandr arc-gtk-theme arc-icon-theme auto-cpufreq brave-bin candy-icons-git cantarell-fonts composer dconf-editor docker docker-compose dropbox exa feh file-roller filezilla firefox flatpak fzf gdal gentium-plus-font gimp gimp-help-pt_br gnu-free-fonts gparted htop imagemagick img2pdf inter-font jq keepassxc keychain libreoffice-fresh libreoffice-fresh-pt-br man meld mousetweaks neofetch ninja noto-fonts noto-fonts-cjk noto-fonts-emoji nss-mdns openbsd-netcat otf-font-awesome-5 papirus-icon-theme pavucontrol pcmanfm pdftk pinta python-beautifulsoup4 ranger ripgrep rstudio-desktop-bin scrot siji-git sof-firmware sublime-text terminus-font tex-gyre-fonts texlive-basic texlive-bibtexextra texlive-bin texlive-binextra texlive-context texlive-fontsextra texlive-fontsrecommended texlive-fontutils texlive-formatsextra texlive-langportuguese texlive-latex texlive-latexextra texlive-latexrecommended texlive-luatex texlive-mathscience texlive-meta texlive-metapost texlive-pictures texlive-pstricks texlive-xetex texstudio the_silver_searcher tldr ttf-anonymous-pro ttf-bitstream-vera ttf-cascadia-code ttf-croscore ttf-dejavu ttf-droid ttf-fantasque-sans-mono ttf-fira-code ttf-fira-mono ttf-font-awesome ttf-hack ttf-ibm-plex ttf-inconsolata ttf-jetbrains-mono ttf-liberation ttf-liberation ttf-linux-libertine ttf-material-design-icons-git ttf-meslo ttf-monofur ttf-ms-fonts ttf-opensans ttf-roboto ttf-ubuntu-font-family ttf-unifont unzip usbutils vifm vim-spell-pt vlc wget wmctrl xdotool xournalpp yasm zathura zathura-djvu zathura-pdf-mupdf zathura-ps zplug yazi github-desktop-bin fragments hyprland xdg-desktop-portal-hyprland waybar wofi hyprpaper hyprcursor hyprutils hyprwayland-scanner grim slurp hyprpicker xdg-desktop-portal-wlr hyprshot hyprlock hypridle fd luarocks lazydocker tmux grub-theme-vimix fwupd wezterm atuin bitwarden lazygit wlogout starship kitty dmd stow qtile fish

git clone https://github.com/neovim/neovim

cd neovim/

git checkout stable

make CMAKE_BUILD_TYPE=RelWithDebInfo

sudo make install

cd ~

rm -rf neovim

cd ~

sudo rm /etc/systemd/sleep.conf

sudo ln -s /home/jfreitas/GitHub/dot/Arch/sleep.conf/sleep.conf /etc/systemd/

sudo rm /etc/mkinitcpio.conf

sudo ln -s /home/jfreitas/GitHub/dot/Arch/mkinitcpio/mkinitcpio.conf /etc/ 

sudo rm /etc/pacman.conf

sudo ln -s ~/GitHub/dot/Arch/pacman/pacman.conf /etc/

sudo rm /etc/default/grub

sudo ln -s ~/GitHub/dot/Arch/grub/grub /etc/default/

sudo rm -rf /etc/libvirt

sudo ln -s ~/GitHub/dot/Arch/libvirt /etc/libvirt

sudo systemctl enable docker

sudo systemctl enable --now auto-cpufreq.service

sudo usermod -aG docker jfreitas

sudo mkinitcpio -P

sudo grub-mkconfig -o /boot/grub/grub.cfg

sudo chsh -s $(which fish) jfreitas

curl https://pyenv.run | bash
