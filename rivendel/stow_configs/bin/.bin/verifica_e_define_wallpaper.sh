#!/bin/bash

cd /home/jfreitas/.bin/

if ! pgrep -x 'wallpaper.sh' >/dev/null; then
    ./wallpaper.sh
fi
