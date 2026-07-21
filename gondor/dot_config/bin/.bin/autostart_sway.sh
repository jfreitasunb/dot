#!/usr/bin/bash

killall dropbox

dropbox start &

#systemctl --user start gnome-keyring-daemon.service &

#gnome-keyring-daemon --start --components="pkcs11,secrets,ssh" &

pam_kwallet_init &

kwalletd6 &

waybar -c /home/jfreitas/.config/waybar/config_sway.jsonc &
