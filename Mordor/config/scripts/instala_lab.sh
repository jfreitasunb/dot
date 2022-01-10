#!/bin/bash
apt update

apt upgrade -y

apt install -y aptitude arduino libclang-dev libgconf-2-4 libcanberra-gtk-module gnuplot gfortran python3.7 texlive-full texstudio r-base libgtksourceview-3.0-dev vim openssh-server openssh-client

cd  /home/aluno/Downloads

wget http://www.geogebra.net/linux/pool/main/g/geogebra-classic/geogebra-classic_6.0.564.0-201910231438_amd64.deb

wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb

wget https://download1.rstudio.org/desktop/bionic/amd64/rstudio-1.2.5033-amd64.deb

dpkg -i geogebra-classic_6.0.564.0-201910231438_amd64.deb

dpkg -i google-chrome-stable_current_amd64.deb

dpkg -i rstudio-1.2.5033-amd64.deb

cd ..

add-apt-repository ppa:avsm/ppa -y

apt update

apt install opam -y

opam init << ANSWERS
N
y
ANSWERS

opam switch create 4.05.0 

opam install ocamlfind lablgtk3 lablgtk3-sourceview3 << ANSWERS
Y
ANSWERS

eval $(opam env)

git clone https://github.com/coq/coq.git

cd coq

./configure -bindir /usr/local/bin -libdir /usr/local/lib/coq -configdir /etc/xdg/coq -datadir /usr/local/share/coq -mandir /usr/local/share/man -docdir /usr/local/share/doc/coq -coqdocdir /usr/local/share/texmf/tex/latex/misc

make

umask 022

make install

cd

rm -rf coq

coqide&

geogebra&

rstudio&

arduino&

google-chrome&

texstudio&

sleep 45

pkill coqide

pkill geogebra

pkill rstudio

pkill arduino

pkill google-chrome

pkill texstudio

echo -e "teste\nteste" | passwd root

cp -R /home/aluno /home/aluno_modelo

rm /home/aluno_modelo/instala_lab.sh

rm /home/aluno_modelo/Downloads/*

touch /root/ultima_limpeza

chown root:root /root/ultima_limpeza

echo 0 > /root/ultima_limpeza

deluser aluno sudo

#instalar script de limpeza
#rebootar