#!/bin/bash
killall hyprpaper
WALLPAPER_DIR="${HOME}/OneDrive/Pictures/Wallpapers"

for display in $(hyprctl monitors | grep "Monitor" | cut -d " " -f 2); do
	wallpaper="$(find "$WALLPAPER_DIR" -type f | shuf -n 1)"
	wallpaper2="$(find "$WALLPAPER_DIR" -type f | shuf -n 1)"
	echo "preload = $wallpaper" > /home/jfreitas/.config/hypr/hyprpaper.conf
	echo "wallpaper = eDP-1,$wallpaper" >> /home/jfreitas/.config/hypr/hyprpaper.conf
	echo "preload = $wallpaper2" >> /home/jfreitas/.config/hypr/hyprpaper.conf
	echo "wallpaper = HDMI-A-1,$wallpaper2" >> /home/jfreitas/.config/hypr/hyprpaper.conf
	echo "splash = false" >> /home/jfreitas/.config/hypr/hyprpaper.conf
	echo "ipc = off" >> /home/jfreitas/.config/hypr/hyprpaper.conf
done

hyprpaper &
