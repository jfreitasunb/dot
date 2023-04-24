cd ~
echo "max_parallel_downloads=10" >> sudo tee -a /etc/dnf/dnf.conf

echo "fastestmirror=True" >> sudo tee -a /etc/dnf/dnf.conf 

sudo dnf update

sudo dnf upgrade

sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo

sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc

sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg

sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo

sudo dnf install -y brave-browser syncthing sublime-text ninja-build cmake gcc make unzip gettext curl alacritty xmonad xmobar

git clone https://github.com/neovim/neovim

cd neovim/

git checkout stable

make CMAKE_BUILD_TYPE=RelWithDebInfo

sudo make install

cd ~

rm -rf neovim

# git clone https://github.com/totoro-ghost/sddm-astronaut.git ~/astronaut/

# cd astronaut/

# rm -rf .git/

# cd ..

# sudo mv astronaut/ /usr/share/sddm/themes/

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

# cd .config/

# ln -s ~/GitHub/dot/Debian/config/alacritty ./

# ln -s ~/GitHub/dot/Debian/config/aliases/ ./

# ln -s ~/GitHub/dot/Debian/config/autorandr/ ./

# ln -s ~/GitHub/dot/Debian/config/nvim/ ./

# ln -s ~/GitHub/dot/Debian/config/picom/ ./

# ln -s ~/GitHub/dot/Debian/config/terminator/ ./

# ln -s ~/GitHub/dot/Debian/config/xmonad/ ./

# ln -s ~/GitHub/dot/Debian/config/xmobar/ ./

# ln -s ~/GitHub/dot/Debian/config/zathura/ ./

# ln -s ~/GitHub/dot/Debian/config/zsh/ ./

# cd ../

# ln -s ~/GitHub/dot/Debian/bin/ ./.bin

# cd .local/share/

# ln -s ~/GitHub/dot/Debian/fonts/ ./

# fc-cache -f -v

# rm .zshenv

# ln -s GitHub/dot/Debian/config/zsh/zshenv ./.zshenv

# ln -s GitHub/dot/Debian/config/R/Renviron ./.Renviron

# ln -s GitHub/dot/Debian/config/R/Renviron.site ./.Renviron.site

# ln -s GitHub/dot/Debian/config/R/Rhistory ./.Rhistory

# ln -s GitHub/dot/Debian/config/R/Rprofile ./.Rprofile

# ln -s GitHub/dot/Gondor/config/latexmkrc ./.latexmkrc

# ln -s GitHub/dot/Debian/config/Xmodmap ./.Xmodmap

# cd /tmp

# wget https://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz

# zcat install-tl-unx.tar.gz | tar xf -

# cd install-tl-*/

# sudo perl ./install-tl --gui
