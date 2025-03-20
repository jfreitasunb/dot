#!/bin/bash
cd ~

sudo dnf install dnf-plugins-core

sudo dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo

sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg

sudo dnf config-manager addrepo --from-repofile=https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo

sudo dnf install brave-browser


flatpak install flathub io.github.shiftey.Desktop

flatpak install flathub com.spotify.Client

flatpak install flathub com.bitwarden.desktop

flatpak install flathub org.texstudio.TeXstudio
