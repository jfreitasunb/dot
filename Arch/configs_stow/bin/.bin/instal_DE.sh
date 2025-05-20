!/bin/bash

cd ~/

sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay && cd yay && makepkg -si

cd ..

rm -rf yay

curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg

echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf

yay -Syy

sleep 5

yay -S --needed adobe-source-code-pro-fonts adobe-source-han-sans-otc-fonts adobe-source-han-serif-otc-fonts arandr arc-gtk-theme arc-icon-theme auto-cpufreq autorandr brave-bin candy-icons-git cantarell-fonts composer dconf-editor dmenu docker docker-compose dropbox dunst exa feh file-roller filezilla firefox flatpak fzf gdal gentium-plus-font gimp gimp-help-pt_br gnome-browser-connector gnu-free-fonts gparted htop imagemagick img2pdf inter-font jq keepassxc keychain libreoffice-fresh libreoffice-fresh-pt-br lxappearance man meld mousetweaks nemo nemo-fileroller nemo-preview neofetch ninja nitrogen noto-fonts noto-fonts-cjk noto-fonts-emoji nss-mdns openbsd-netcat otf-font-awesome-5 papirus-icon-theme pavucontrol pcmanfm pdftk picom pinta playerctl python-beautifulsoup4 ranger ripgrep rstudio-desktop-bin scrot siji-git sof-firmware sublime-text terminus-font tex-gyre-fonts texlive-basic texlive-bibtexextra texlive-bin texlive-binextra texlive-context texlive-fontsextra texlive-fontsrecommended texlive-fontutils texlive-formatsextra texlive-langportuguese texlive-latex texlive-latexextra texlive-latexrecommended texlive-luatex texlive-mathscience texlive-meta texlive-metapost texlive-pictures texlive-pstricks texlive-xetex texstudio the_silver_searcher tldr transmission-gtk trayer ttf-anonymous-pro ttf-bitstream-vera ttf-cascadia-code ttf-croscore ttf-dejavu ttf-droid ttf-fantasque-sans-mono ttf-fira-code ttf-fira-mono ttf-font-awesome ttf-hack ttf-ibm-plex ttf-inconsolata ttf-jetbrains-mono ttf-liberation ttf-liberation ttf-linux-libertine ttf-material-design-icons-git ttf-meslo ttf-monofur ttf-ms-fonts ttf-opensans ttf-roboto ttf-ubuntu-font-family ttf-unifont unzip usbutils vifm vim-spell-pt vlc volumeicon wget wmctrl xdotool xmobar xmonad xmonad-contrib xorg-xauth xorg-xinit xorg-xinit xorg-xmodmap xorg-xrdb xorg-xsetroot xournalpp yasm zathura zathura-djvu zathura-pdf-mupdf zathura-ps zplug yazi github-desktop-bin fragments hyprland xdg-desktop-portal-hyprland waybar wofi hyprpaper hyprcursor hyprutils hyprwayland-scanner grim slurp hyprpicker xdg-desktop-portal-wlr hyprshot swaync hyprlock hypridle fd luarocks laygit lazydocker onedrive tmux grub-theme-vimix fwupd wezterm atuin neovim bitwarden lazygit grub-theme-vimix

git clone https://github.com/neovim/neovim

cd neovim/

git checkout stable

make CMAKE_BUILD_TYPE=RelWithDebInfo

sudo make install

cd ~

rm -rf neovim

cd ~/.config/

rm -rf alacritty aliases autorandr nvim picom terminar xmonad xmobar zathura zsh keepassxc nemo gtk-3.0 autostart systemd texstudio

ln -s ~/GitHub/dot/Arch/config/alacritty ./

ln -s ~/GitHub/dot/Arch/config/aliases/ ./

ln -s ~/GitHub/dot/Arch/config/autorandr/ ./

ln -s ~/GitHub/dot/Arch/config/astronvim-jfreitas ./nvim

ln -s ~/GitHub/dot/Arch/config/picom/ ./

ln -s ~/GitHub/dot/Arch/config/xmonad/ ./

ln -s ~/GitHub/dot/Arch/config/xmobar/ ./

ln -s ~/GitHub/dot/Arch/config/zathura/ ./

ln -s ~/GitHub/dot/Arch/config/zsh/ ./

ln -s ~/GitHub/dot/Arch/config/keepassxc/ ./

ln -s ~/GitHub/dot/Arch/config/nemo/ ./

ln -s ~/GitHub/dot/Arch/config/gtk-3.0 ./

ln -s ~/GitHub/dot/Arch/config/autostart ./

ln -s ~/GitHub/dot/Arch/config/systemd ./

ln -s ~/GitHub/dot/Arch/config/starship.toml ./

mkdir texstudio

cd texstudio

ln -s ~/GitHub/dot/Arch/config/texstudio/texstudio.ini ./

cd ~

ln -s ~/GitHub/dot/Arch/bin/ ./.bin

cd .local/share/

ln -s ~/GitHub/dot/fonts/ ./

fc-cache -f -v

cd ~/.local/share/gnome-shell/

ln -s ~/GitHub/dot/Arch/gnome_extensions ./extensions

cd ~

ln -s GitHub/dot/Gondor/config/latexmkrc ./.latexmkrc

ln -s GitHub/dot/Arch/config/Xmodmap ./.Xmodmap

rm .zshrc

ln -s ~/GitHub/dot/Arch/config/zsh/zshrc ./.zshrc

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

sudo chsh -s $(which zsh) jfreitas

curl https://pyenv.run | bash
