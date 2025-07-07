#!/usr/bin/bash

killall dropbox

dropbox start &

systemctl --user start gnome-keyring-daemon.service &

gnome-keyring-daemon --start --components="pkcs11,secrets,ssh" &
