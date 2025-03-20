#!/bin/bash
# script that changes me GNOME wallpapers in random order

# setting the base path
export wallpaper_path=/home/jfreitas/OneDrive/Pictures/Wallpapers
shopt -s nullglob

# storing images in an array
wallpapers=(
    $wallpaper_path/*.jpg
    $wallpaper_path/*.jpeg
)

# getting array size
wallpapers_size=${#wallpapers[*]}

# looping through wallpapers
while true
do
    # generating a random index
    random_index=$(($RANDOM % $wallpapers_size))
    # setting the random wallpaper
    #gsettings set org.gnome.desktop.background picture-uri-dark file://${wallpapers[$random_index]}
    # trocar pelo comando abaixo se não estiver usando o tema escuro
    gsettings set org.gnome.desktop.background picture-uri file://${wallpapers[$random_index]}
    # keeping it active for set time
    #sleep 1 && exit
    sleep 8200
done
