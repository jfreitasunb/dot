#!/bin/bash
cd ~/avell_teclado/module
sudo make clean
make
sudo make install
sudo install -m644 clevo-xsm-wmi.ko /lib/modules/$(uname -r)/extra
sudo depmod
sudo tee /etc/modprobe.d/clevo-xsm-wmi.conf <<< 'options clevo-xsm-wmi kb_color=green,green,green kb_brightness=1 kb_off=0'

cd ~/input-wacom

if test -x ./autogen.sh; then ./autogen.sh; else ./configure; fi && make && sudo make install || echo "Build Failed"

sudo reboot