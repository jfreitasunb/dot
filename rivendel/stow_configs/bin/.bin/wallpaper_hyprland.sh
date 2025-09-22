#!/usr/bin/env bash

# Define o caminho para o arquivo de bloqueio
LOCKFILE="/tmp/wallpaper_hyprland.lock"

# Tenta obter o bloqueio do arquivo. O '-n' faz com que o comando falhe
# imediatamente se o bloqueio não puder ser obtido.
# O 'exec 200>$LOCKFILE' abre o arquivo de bloqueio no descritor de arquivo 200.
exec 200>"$LOCKFILE"
flock -n 200 || { echo "Outra instância do script já está em execução."; exit 1; }

while true; do	
	hyprctl hyprpaper unload all
	# Sets a random wallpaper with hyprpaper

	wallpapers=($(ls -d $HOME/OneDrive/Pictures/Wallpapers/*))
	#wallpapers+=($(ls -d /usr/share/hyprland/wall*))

	wall=${wallpapers[$RANDOM % ${#wallpapers[@]}]}

	hyprctl hyprpaper preload $wall
	hyprctl hyprpaper wallpaper ,$wall

	echo "preload = $wall" >~/.config/hypr/hyprpaper.conf
	echo "wallpaper = , $wall" >>~/.config/hypr/hyprpaper.conf
	
	sleep 120m

done
