#!/bin/bash
##############################################################################################################################
######## Driver do teclado Avell
##############################################################################################################################
vkernel=$(uname --kernel-release)

/usr/bin/modprobe /lib/modules/$(echo $vkernel)/updates/clevo-xsm-wmi.ko.zst