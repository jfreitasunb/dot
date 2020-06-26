#!/bin/bash
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -

sudo apt-get install apt-transport-https

echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

sudo bash -c 'echo deb https://vagrant-deb.linestarve.com/ any main > /etc/apt/sources.list.d/wolfgang42-vagrant.list'

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-key AD319E0F7CFFA38B4D9F6E55CE3F3DE92099F7A4 D2BABDFD63EA9ECAB4E09C7228A873EA3C7C705F

sudo apt-get update

apt install -y vagrant xournalpp bzip2 cabextract autoconf automake  curl dkms duplicity exfat-fuse exfat-utils ffmpeg file file-roller filezilla folder-color g++ gfortran gimp git gnuplot gnuplot-data gnuplot-nox gparted grub-customizer h264enc hddtemp hdparm htop imagemagick lame latexmk less lm-sensors make meld mencoder mkvtoolnix ncurses-base neofetch nodejs npm ntfs-3g p7zip p7zip-full r-base r-base-core r-base-dev r-base-html r-cran-boot r-cran-class r-cran-cluster r-cran-codetools r-cran-foreign r-cran-kernsmooth r-cran-lattice r-cran-mass r-cran-matrix r-cran-mgcv r-cran-nlme r-cran-nnet r-cran-rpart r-cran-spatial r-cran-survival r-doc-html r-recommended rsync sublime-text tcpdump telnet terminator tex-common tex-gyre texlive texlive-base texlive-binaries texlive-extra-utils texlive-font-utils texlive-fonts-extra texlive-fonts-extra-links texlive-fonts-recommended texlive-formats-extra texlive-lang-greek texlive-lang-portuguese texlive-latex-base texlive-latex-extra texlive-latex-recommended texlive-pictures texlive-plain-generic texlive-pstricks texlive-publishers texlive-science texlive-xetex ttf-bitstream-vera ttf-dejavu-core ttf-mscorefonts-installer unrar unzip update-manager update-manager-core vim vim-common vim-runtime vim-tiny vlc wget x264 zip zsh zsh-common network-manager-openvpn-gnome network-manager-openvpn tree build-essential linux-headers-$(uname -r) aptitude gnome-tweaks git qemu-kvm libvirt-clients libvirt-daemon-system bridge-utils virt-manager fonts-firacode libvirt-dev papirus-icon-theme php

cd ~/Downloads/

wget https://cloud.gastecnologia.com.br/bb/downloads/ws/warsaw_setup64.deb

wget https://download1.rstudio.org/desktop/bionic/amd64/rstudio-1.2.5042-amd64.deb

wget https://linux.dropbox.com/packages/ubuntu/dropbox_2020.03.04_amd64.deb

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

dpkg -i *.deb

apt -f install

cd ../

timedatectl set-local-rtc 1 --adjust-system-clock

sed -i 's/\/home\/jfreitas:\/bin\/bash/\/home\/jfreitas:\/bin\/zsh/g' /etc/passwd

#Executar somente na primeira vez, caso dê algum erro.
./teclado_avell.sh