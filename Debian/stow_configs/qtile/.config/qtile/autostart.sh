#!/usr/bin/bash -x

COLORSCHEME=dracula

dunst -conf "$HOME"/.config/dunst/"$COLORSCHEME" &

killall dropbox

killall wallpaper.sh

/home/jfreitas/.bin/seta_keyboard_login.sh &

/home/jfreitas/.bin/seta_monitores_login.sh &

dropbox start &

blueman-applet &

/home/jfreitas/.bin/wallpaper.sh &
