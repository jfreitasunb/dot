#!/bin/bash
cd ~

sudo dnf install dnf-plugins-core

sudo dnf config-manager addrepo --from-repofile=https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo





sudo dnf install brave-browser


flatpak install flathub io.github.shiftey.Desktop

flatpak install flathub com.spotify.Client
