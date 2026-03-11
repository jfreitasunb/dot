#!/usr/bin/bash -x

COLORSCHEME=dracula

dunst -conf "$HOME"/.config/dunst/"$COLORSCHEME" &

killall dropbox

killall wallpaper.sh

/home/jfreitas/.bin/seta_monitores_login.sh &

dropbox start &

/home/jfreitas/.bin/wallpaper.sh &

picom -b --config ~/.config/picom/picom.conf &

systemctl --user start gnome-keyring-daemon.service &

gnome-keyring-daemon --start --components="pkcs11,secrets,ssh" &

#greenclip daemon &
