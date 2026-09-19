#!/usr/bin/bash -x

killall dropbox

dropbox start &

nm-applet &

~/.bin/notificar_musica.sh &

#systemctl --user start gnome-keyring-daemon.service &

#gnome-keyring-daemon --start --components="pkcs11,secrets,ssh" &

waybar -c /home/jfreitas/.config/waybar/config_sway.jsonc &