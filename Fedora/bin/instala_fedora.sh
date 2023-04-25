cd ~

echo "max_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf > /dev/null 2>&1

echo "fastestmirror=True" | sudo tee -a /etc/dnf/dnf.conf > /dev/null 2>&1

sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo

sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc

sudo rpm -v --import https://download.sublimetext.com/sublimehq-rpm-pub.gpg

sudo dnf config-manager --add-repo https://download.sublimetext.com/rpm/stable/x86_64/sublime-text.repo

sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm

sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

sudo dnf update

sudo dnf upgrade

sudo dnf install -y brave-browser syncthing sublime-text ninja-build cmake gcc make unzip gettext curl alacritty xmonad xmobar neovim tcl tk picom qemu ranger virt-manager vlc transmission-gtk zathura zathura-cb zathura-djvu zathura-pdf-poppler zathura-ps zsh nemo nemo-fileroller meld dconf-editor python3-pip nodejs npm onedrive texlive

sudo grub2-editenv - unset menu_auto_hide

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
