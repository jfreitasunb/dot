#!/bin/bash
VERSION=43
#Instala atualizações sem confirmação

sudo dnf update -y

#Para atualizar a versão do Fedora

sudo dnf upgrade --refresh

sudo dnf system-upgrade download --releasever=$VERSION --allowerasing -y

sudo dnf system-upgrade reboot

#RPM Fusion e Codecs

sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

sudo dnf config-manager setopt rpmfusion-free.enabled=1
sudo dnf config-manager setopt rpmfusion-free-updates.enabled=1
sudo dnf config-manager setopt rpmfusion-free-rawhide.enabled=0

sudo dnf swap ffmpeg-free ffmpeg --allowerasing -y

sudo dnf group upgrade multimedia -y

sudo dnf group upgrade core -y


#Atualizando firmware

sudo fwupdmgr refresh --force
sudo fwupdmgr get-devices
sudo fwupdmgr get-updates
sudo fwupdmgr update

#Instalando pacotes

sudo dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo

sudo dnf install nvim zsh texlive-scheme-full texstudio cargo meld onedrive brave-browser stow bat fzf keepassxc vlc alacritty stow fragments -y

#Dependências para o Manim

sudo dnf install pango-devel -y

#Instalando sensores

sudo dnf install sensors -y

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

#Virtualização

sudo dnf install @virtualization -y

sudo systemctl enable libvirtd --now

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

sudo systemctl enable docker --now

sudo usermod -aG docker jfreitas

#Instalando Flatpaks

sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install flathub com.bitwarden.desktop -y

flatpak install flathub io.github.shiftey.Desktop -y

flatpak install flathub com.spotify.Client -y

flatpak install flathub org.geogebra.GeoGebra -y

#Instalando GIMP, Pinta e Xournalpp

sudo dnf install gimp pinta xournalpp -y

#Instala o lazygit

sudo dnf install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release -y

sudo dnf install lazygit -y

#Arquivos de configuração

cd ~

rm -rf ~/.config

cd ~/GitHub/dot/numenor/dot_config/

stow -t /home/jfreitas/ *

cd ~/GitHub/dot/

ln -s ~/GitHub/dot/fonts ~/.local/share/

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

#Ativando configurações personalizadas

sudo rm -rf /etc/systemd/sleep.conf

sudo rm -rf /etc/systemd/logind.conf

sudo ln -s ~/GitHub/dot/numenor/logind/sleep.conf /etc/systemd/sleep.conf

sudo ln -s ~/GitHub/dot/numenor/logind/logind.conf /etc/systemd/logind.conf

sudo ln -s /usr/lib/systemd/system/systemd-suspend-then-hibernate.service /etc/systemd/system/systemd-suspend.service

sudo rm -rf /etc/libvirt/qemu

sudo rm -rf /etc/libvirt/qemu.conf

sudo rm -rf /etc/libvirt/storage

sudo ln -s ~/GitHub/dot/numenor/maquinas_virtuais/qemu /etc/libvirt/

sudo ln -s ~/GitHub/dot/numenor/maquinas_virtuais/storage /etc/libvirt/

sudo ln -s /home/jfreitas/GitHub/dot/numenor/maquinas_virtuais/qemu.conf /etc/libvirt/

sudo systemctl enable fstrim.timer
