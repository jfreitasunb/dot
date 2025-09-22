#!/bin/bash

# Define o caminho para o arquivo de bloqueio
LOCKFILE="/tmp/wallpaper_xmonad.lock"

# Tenta obter o bloqueio do arquivo. O '-n' faz com que o comando falhe
# imediatamente se o bloqueio não puder ser obtido.
# O 'exec 200>$LOCKFILE' abre o arquivo de bloqueio no descritor de arquivo 200.
exec 200>"$LOCKFILE"
flock -n 200 || { echo "Outra instância do script já está em execução."; exit 1; }

# use nullglob in case there are no matching files
shopt -s nullglob

# create an array with all the filer/dir inside ~/myDir
arr=(/home/jfreitas/OneDrive/Pictures/Wallpapers/*)


# Verifica se existe um processo 'sleep 7207'
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
    sleep 120m
done
