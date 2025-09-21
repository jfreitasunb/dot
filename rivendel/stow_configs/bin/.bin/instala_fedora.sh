#!/bin/bash

cd ~

sudo dnf install dnf-plugins-core

sudo dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo

sudo dnf copr enable wezfurlong/wezterm-nightly

sudo dnf copr enable lihaohong/yazi

sudo dnf copr enable eddsalkield/swaylock-effects

sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg

sudo dnf config-manager addrepo --from-repofile=https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo

sudo dnf install brave-browser wezterm yazi onedrive neovim sublime-text mscore-fonts-all fontconfig bat arandr feh flameshot fzf keepassxc p7zip pavucontrol pdftk-java picom r root-r-tools ranger rsync virt-manager vlc zathura zathura-cb zathura-djvu zathura-pdf-poppler zathura-ps zsh nemo nemo-fileroller meld dconf-editor ImageMagick yasm texlive-scheme-full latexmk sublime-text zoxide ripgrep luarocks xclip tmux stow xmonad xmobar yad blueman htop sway wofi waybar wlogout swayidle rofi network-manager-applet copyq gnome-extensions-app virt-manager qemu make automake gcc gcc-c++ kernel-devel meson swaylock-effects

git clone https://github.com/Raymo111/i3lock-color.git

cd i3lock-color

./install-i3lock-color.sh

cd ~

rm -rf i3lock-color

flatpak install flathub io.github.shiftey.Desktop

flatpak install flathub com.bitwarden.desktop

flatpak install flathub com.spotify.Client

flatpak install flathub org.texstudio.TeXstudio

flatpak install flathub com.discordapp.Discord

flatpak install flathub com.github.xournalpp.xournalpp

sudo dnf remove gnome-games gnome-contacts gnome-weather gnome-maps gnome-music rhythmbox gnome-characters gnome-clocks cups cups-common apache2-bin gnome-user-share libapache2-mod-dnssd

sudo rm -rf /etc/systemd/sleep.conf

sudo rm -rf /etc/systemd/logind.conf

sudo ln -s ~/GitHub/dot/rivendel/logind/sleep.conf /etc/systemd/sleep.conf

sudo ln -s ~/GitHub/dot/rivendel/logind/logind.conf /etc/systemd/logind.conf

sudo rm -rf /etc/libvirt/qemu

sudo rm -rf /etc/libvirt/qemu.conf

sudo rm -rf /etc/libvirt/storage

sudo ln -s ~/GitHub/dot/rivendel/maquinas_virtuais/qemu /etc/libvirt/

sudo ln -s ~/GitHub/dot/rivendel/maquinas_virtuais/storage /etc/libvirt/

sudo ln -s /home/jfreitas/GitHub/dot/rivendel/maquinas_virtuais/qemu.conf /etc/libvirt/

sudo systemctl enable fstrim.timer

sudo systemctl enable libvirtd

sudo usermod -aG libvirt jfreitas

sudo chsh -s $(which zsh) jfreitas

echo 'NotShowIn=GNOME;' | sudo tee -a /etc/xdg/autostart/blueman.desktop

curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

cd ~

rm .zshrc

rm .zsh_history

rm -rf ~/.config

rm -rf ~/.local/share/gnome-shell

cd ~/GitHub/dot/rivendel/stow_configs/

stow -t /home/jfreitas/ *

cd ~/.local/share/fonts/

fc-cache -f -v

cd ~

curl https://pyenv.run | bash

curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh

curl -sS https://starship.rs/install.sh | sh
