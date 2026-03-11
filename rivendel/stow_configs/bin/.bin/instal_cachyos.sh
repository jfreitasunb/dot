!/bin/bash

cd ~

curl -O https://download.sublimetext.com/sublimehq-pub.gpg && sudo pacman-key --add sublimehq-pub.gpg && sudo pacman-key --lsign-key 8A8F901A && rm sublimehq-pub.gpg

echo -e "\n[sublime-text]\nServer = https://download.sublimetext.com/arch/stable/x86_64" | sudo tee -a /etc/pacman.conf

paru -Syy

sleep 5

paru -S --needed arandr brave-bin dconf-editor dropbox exa feh file-roller filezilla flatpak fzf gdal gimp gimp-help-pt_br gparted htop imagemagick img2pdf jq keepassxc keychain libreoffice-fresh libreoffice-fresh-pt-br man meld mousetweaks noto-fonts noto-fonts-cjk noto-fonts-emoji nss-mdns openbsd-netcat otf-font-awesome-5 papirus-icon-theme pavucontrol pcmanfm pdftk pinta ranger ripgrep scrot sof-firmware sublime-text terminus-font tex-gyre-fonts texlive-basic texlive-bibtexextra texlive-bin texlive-binextra texlive-context texlive-fontsextra texlive-fontsrecommended texlive-fontutils texlive-formatsextra texlive-langportuguese texlive-latex texlive-latexextra texlive-latexrecommended texlive-luatex texlive-mathscience texlive-meta texlive-metapost texlive-pictures texlive-pstricks texlive-xetex the_silver_searcher unzip usbutils vifm vim-spell-pt vlc wget xdotool xournalpp yasm zathura zathura-djvu zathura-pdf-mupdf zathura-ps zplug yazi fragments grim slurp fd luarocks tmux fwupd lazygit starship dmd stow sbctl blueman strace trash tk cliphist biber rofi greenclip xclip copyq dunst picom xorg xmonad xmonad-contrib xmonad-extras xmonad-utils xmobar betterlockscreen onedrive-abraunegg vlc-plugins-all r hyprland xdg-desktop-portal-hyprland waybar wofi hyprpaper hyprcursor hyprutils hyprwayland-scanner hyprpicker xdg-desktop-portal-wlr hyprshot hyprlock hypridle libvirt virt-manager zoxide qemu-full neovim libappindicator-gtk3 lua wezterm-git

sudo rm /etc/systemd/sleep.conf

sudo ln -s /home/jfreitas/GitHub/dot/rivendel/logind/sleep.conf /etc/systemd/

sudo rm /etc/systemd/logind.conf

sudo ln -s /home/jfreitas/GitHub/dot/rivendel/logind/logind.conf /etc/systemd/

sudo rm -rf /etc/libvirt/qemu

sudo rm -rf /etc/libvirt/qemu.conf

sudo rm -rf /etc/libvirt/storage

sudo ln -s ~/GitHub/dot/rivendel/maquinas_virtuais/qemu /etc/libvirt/

sudo ln -s ~/GitHub/dot/rivendel/maquinas_virtuais/storage /etc/libvirt/

sudo ln -s /home/jfreitas/GitHub/dot/rivendel/maquinas_virtuais/qemu.conf /etc/libvirt/

sudo usermod -aG libvirt jfreitas

sudo systemctl enable libvirtd

sudo chsh -s $(which zsh) jfreitas

flatpak install flathub io.github.shiftey.Desktop

flatpak install flathub com.bitwarden.desktop

flatpak install flathub com.spotify.Client

flatpak install flathub org.texstudio.TeXstudio

flatpak install flathub com.discordapp.Discord

sudo ln -s /usr/lib/systemd/system/systemd-suspend-then-hibernate.service /etc/systemd/system/systemd-suspend.service

echo 'NotShowIn=GNOME;' | sudo tee -a /etc/xdg/autostart/blueman.desktop

rm -rf ~/.config

rm -rf ~/.local/share/gnome-shell

rm ~/.zshrc

rm ~/.zsh_history

cd ~/GitHub/dot/rivendel/stow_configs/

stow -t /home/jfreitas/ *

cd ~/.local/share/fonts/

fc-cache -f -v

curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh
