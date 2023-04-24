cd ~
echo "max_parallel_downloads=10" >> sudo tee -a /etc/dnf/dnf.conf

echo "fastestmirror=True" >> sudo tee -a /etc/dnf/dnf.conf 

sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo

sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc

sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg

sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo

sudo dnf update

sudo dnf upgrade

sudo dnf install -y brave-browser syncthing sublime-text ninja-build cmake gcc make unzip gettext curl alacritty xmonad xmobar neovim tck tk

sudo grub2-editenv - unset menu_auto_hide

# curl -fsS https://dlang.org/install.sh | bash -s dmd

# source $(echo ~/dlang/*/)/activate

# git clone https://github.com/abraunegg/onedrive.git

# cd onedrive

# ./configure --enable-notifications

# make clean; make;

# sudo make install

# deactivate

# cd ..

# sudo rm -rf onedrive

# systemctl --user enable syncthing.service --now

# systemctl --user enable onedrive.service 

cd ~/.config/

ln -s ~/GitHub/dot/Fedora/config/alacritty ./

ln -s ~/GitHub/dot/Fedora/config/aliases/ ./

ln -s ~/GitHub/dot/Fedora/config/autorandr/ ./

ln -s ~/GitHub/dot/Fedora/config/nvim/ ./

ln -s ~/GitHub/dot/Fedora/config/picom/ ./

ln -s ~/GitHub/dot/Fedora/config/terminator/ ./

ln -s ~/GitHub/dot/Fedora/config/xmonad/ ./

ln -s ~/GitHub/dot/Fedora/config/xmobar/ ./

ln -s ~/GitHub/dot/Fedora/config/zathura/ ./

ln -s ~/GitHub/dot/Fedora/config/zsh/ ./

cd ~

ln -s ~/GitHub/dot/Fedora/bin/ ./.bin

cd .local/share/

ln -s ~/GitHub/dot/Fedora/fonts/ ./

fc-cache -f -v

rm .zshenv

ln -s GitHub/dot/Fedora/config/zsh/zshenv ./.zshenv

ln -s GitHub/dot/Fedora/config/R/Renviron ./.Renviron

ln -s GitHub/dot/Fedora/config/R/Renviron.site ./.Renviron.site

ln -s GitHub/dot/Fedora/config/R/Rhistory ./.Rhistory

ln -s GitHub/dot/Fedora/config/R/Rprofile ./.Rprofile

ln -s GitHub/dot/Gondor/config/latexmkrc ./.latexmkrc

ln -s GitHub/dot/Fedora/config/Xmodmap ./.Xmodmap

cd /tmp

wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz

zcat install-tl-unx.tar.gz | tar xf -

cd install-tl-*/

sudo perl ./install-tl --gui
