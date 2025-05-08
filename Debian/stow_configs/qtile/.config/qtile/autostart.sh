#!/usr/bin/env bash

COLORSCHEME=dracula

dunst -conf "$HOME"/.config/dunst/"$COLORSCHEME" &

/home/jfreitas/.bin/seta_keyboard_login.sh
