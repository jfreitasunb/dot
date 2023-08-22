#!/bin/bash
##############################################################################################################################
######## Driver do teclado Avell
##############################################################################################################################

cd /home/jfreitas/scripts/avell_teclado/module

sudo make clean

make

sudo make install

for i in /lib/modules/*; do
    if [ -d $i'/extra/' ]; then
        sudo install -m644 clevo-xsm-wmi.ko $i'/extra'

        sudo depmod
    fi
done

sudo modprobe clevo-xsm-wmi

sudo tee /etc/modprobe.d/clevo-xsm-wmi.conf <<< 'options clevo-xsm-wmi kb_color=red,red,red kb_brightness=1 kb_off=0'