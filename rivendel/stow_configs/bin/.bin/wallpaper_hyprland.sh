#!/usr/bin/bash -x

# Define o caminho para o arquivo de bloqueio
LOCKFILE="/tmp/wallpaper_hyprland.lock"

# Tenta obter o bloqueio do arquivo. O '-n' faz com que o comando falhe
# imediatamente se o bloqueio não puder ser obtido.
# O 'exec 200>$LOCKFILE' abre o arquivo de bloqueio no descritor de arquivo 200.
exec 200>"$LOCKFILE"
flock -n 200 || {
    echo "Outra instância do script já está em execução."
    exit 1
}

while true; do

    wallpapers=($(ls -d $HOME/OneDrive/Pictures/Wallpapers/*))
    #wallpapers+=($(ls -d /usr/share/hyprland/wall*))

    wall1=${wallpapers[$RANDOM % ${#wallpapers[@]}]}

    wall2=${wallpapers[$RANDOM % ${#wallpapers[@]}]}

    echo "wallpaper {
	monitor = eDP-1
	path = $wall1
	fit_mode = cover
    }" >~/.config/hypr/hyprpaper.conf

    echo "wallpaper {
	monitor = HDMI-A-1
	path = $wall2
	fit_mode = cover
    }" >>~/.config/hypr/hyprpaper.conf

    hyprpaper

    sleep 120m

done
