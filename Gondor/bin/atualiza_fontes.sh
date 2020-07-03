#!/bin/bash
cd /home/jfreitas

git clone https://github.com/ryanoasis/nerd-fonts.git

cd nerd-fonts

./install.sh FiraMono

./install.sh InconsolataGo

./install.sh Ubuntu

./install.sh UbuntuMono

./install.sh Meslo

./install.sh Monoid

./install.sh FiraCode

cd ../

rm -rf nerd-fonts