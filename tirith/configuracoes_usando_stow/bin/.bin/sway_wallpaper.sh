#!/bin/bash

# Define o caminho para o arquivo de bloqueio
LOCKFILE="/tmp/wallpaper_sway.lock"

# Tenta obter o bloqueio do arquivo. O '-n' faz com que o comando falhe
# imediatamente se o bloqueio não puder ser obtido.
# O 'exec 200>$LOCKFILE' abre o arquivo de bloqueio no descritor de arquivo 200.
exec 200>"$LOCKFILE"
flock -n 200 || { echo "Outra instância do script já está em execução."; exit 1; }

while true; do

    PIC=($(find ~/OneDrive/Pictures/Wallpapers -type f | shuf -n 2 --random-source=/dev/random))

    swaymsg output "eDP-1" bg "${PIC[0]}" fill >/dev/null
    swaymsg output "HDMI-A-1" bg "${PIC[1]}" fill >/dev/null

    sleep 120m

done
