#!/bin/bash
# use nullglob in case there are no matching files
shopt -s nullglob

# create an array with all the filer/dir inside ~/myDir
arr=(/home/jfreitas/OneDrive/Pictures/Wallpapers/*)

# Intervalo entre mudanças (2 horas = 7200 segundos)
INTERVALO=7200

while true; do
    if [ "$(xrandr | grep -c 'HDMI-1 connected')" -ge 1 ]; then
        i=$(shuf -i0-${#arr[@]} -n1)
        j=$(shuf -i0-${#arr[@]} -n1)
        feh --bg-fill ${arr[$i]} ${arr[$j]}
    else
        i=$(shuf -i0-${#arr[@]} -n1)
        feh --bg-fill ${arr[$i]}
    fi

    # Esperar o intervalo antes de mudar novamente
    sleep "$INTERVALO"
done

