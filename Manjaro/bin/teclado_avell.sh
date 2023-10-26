#!/bin/bash
##############################################################################################################################
######## Driver do teclado Avell
##############################################################################################################################

cd /home/jfreitas/scripts/avell_teclado/module

sudo make clean

make

sudo make install

vkernel=$(uname --kernel-release)

if [ -d /lib/modules/'$vkernel'/extra/ ]; then
    sudo install -m644 clevo-xsm-wmi.ko /lib/modules/'$vkernel'/extra

    sudo depmod
fi

sudo modprobe /lib/modules/$(echo $vkernel)/updates/clevo-xsm-wmi.ko.zst

sudo tee /etc/modprobe.d/clevo-xsm-wmi.conf <<< 'options clevo-xsm-wmi kb_color=green,green,green kb_brightness=1 kb_off=0'
