#!/bin/bash
VERSION=43
#Instala atualizações sem confirmação

sudo dnf update -y

#Para atualizar a versão do Fedora

sudo dnf upgrade --refresh

sudo dnf system-upgrade download --releasever=$VERSION --allowerasing -y

sudo dnf system-upgrade reboot

#Instalando pacotes

sudo dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo

sudo dnf install nvim zsh texlive-scheme-full texstudio cargo meld onedrive brave-browser stow bat fzf keepassxc vlc gparted alacritty stow gnome-tweaks gnome-extensions-app -y

sudo dnf copr enable wezfurlong/wezterm-nightly

sudo dnf install wezterm

sudo dnf update wezterm


#Instalando o Eza
cd ~

git clone https://github.com/eza-community/eza.git

cd eza

cargo install --path .

cd ~

cd ~/.cargo/bin

mv eza exa

cd ~

rm -rf eza

#Instalando o wezterm

curl https://sh.rustup.rs -sSf | sh -s

git clone --depth=1 --branch=main --recursive https://github.com/wezterm/wezterm.git

cd wezterm

git submodule update --init --recursive

./get-deps

cargo build --release

cd assets

sudo cp wezterm.desktop /usr/share/applications/

sudo cp icon/terminal.png /usr/share/icons/hicolor/128x128/apps/org.wezfurlong.wezterm.png

cd ../

cd target/release/

sudo cp wezterm wezterm-gui wezterm-mux-server /usr/bin/

cd ~

rm -rf wezterm

#Instalando o yazi

sudo dnf copr enable lihaohong/yazi

sudo dnf install yazi -y

#Virtualização

sudo dnf install @virtualization -y

sudo systemctl enable libvirtd

sudo usermod -a -G libvirt jfreitas

#Instalando fontes windows

sudo dnf install mscore-fonts-all -y

#Instalando o R

sudo dnf install R -y

#Instalando zoxide

sudo dnf install zoxide -y

#Instalando o zplug

cd ~

git clone https://github.com/zplug/zplug ~/.local/share/zplug

#Instalando o Zathura(leitor de PDF)

sudo dnf install zathura zathura-cb zathura-djvu zathura-pdf-poppler zathura-ps -y

#Instalando Sublime text

sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg

sudo dnf config-manager addrepo --from-repofile=https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo

sudo dnf install sublime-text -y

#Instalando docker

sudo dnf config-manager addrepo --from-repofile https://download.docker.com/linux/fedora/docker-ce.repo

sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y

sudo systemctl enable docker

sudo usermod -aG docker jfreitas

#Instalando Flatpaks

sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install flathub com.bitwarden.desktop -y

flatpak install flathub io.github.shiftey.Desktop -y

flatpak install flathub com.spotify.Client -y

flatpak install flathub org.geogebra.GeoGebra -y

#Instalando GIMP, Pinta e Xournalpp

sudo dnf install gimp pinta xournalpp -y

#Arquivos de configuração

cd ~

rm -rf ~/.config

cd ~/GitHub/dot/rivendel/configuracoes_usando_stow/

stow -t /home/jfreitas/ *

cd ~/.local/share/fonts/

fc-cache -f -v

cd ~

#Instalando atuin

curl --proto '=https' --tlsv1.2 -LsSf https://setup.atuin.sh | sh

#Instalando starship

curl -sS https://starship.rs/install.sh | sh

#Instalando uv

curl -LsSf https://astral.sh/uv/install.sh | sh

#TMUX

git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

#Mudando o shell para ZSH
sudo chsh -s $(which zsh) jfreitas

#Instalando Sway e dependências

sudo dnf install sway wofi waybar swaylock wlogout network-manager-applet dunst -y

#Ativando configurações personalizadas

sudo rm /etc/default/grub

sudo ln -s ~/GitHub/dot/rivendel/grub/grub-FEDORA /etc/default/grub

sudo grub2-mkconfig -o /boot/grub2/grub.cfg

sudo ln -s ~/GitHub/dot/rivendel/dracut.conf.d/resume.conf /etc/dracut.conf.d

sudo dracut -f

sudo rm -rf /etc/systemd/sleep.conf

sudo rm -rf /etc/systemd/logind.conf

sudo ln -s ~/GitHub/dot/rivendel/logind/sleep.conf /etc/systemd/sleep.conf

sudo ln -s ~/GitHub/dot/rivendel/logind/logind.conf /etc/systemd/logind.conf

sudo ln -s /usr/lib/systemd/system/systemd-suspend-then-hibernate.service /etc/systemd/system/systemd-suspend.service

sudo rm -rf /etc/libvirt/qemu

sudo rm -rf /etc/libvirt/qemu.conf

sudo rm -rf /etc/libvirt/storage

sudo ln -s ~/GitHub/dot/rivendel/maquinas_virtuais/qemu /etc/libvirt/

sudo ln -s ~/GitHub/dot/rivendel/maquinas_virtuais/storage /etc/libvirt/

sudo ln -s /home/jfreitas/GitHub/dot/rivendel/maquinas_virtuais/qemu.conf /etc/libvirt/

sudo systemctl enable fstrim.timer
