#!/bin/bash
#   ____ _                              _____ _                          
#  / ___| |__   __ _ _ __   __ _  ___  |_   _| |__   ___ _ __ ___   ___  
# | |   | '_ \ / _` | '_ \ / _` |/ _ \   | | | '_ \ / _ \ '_ ` _ \ / _ \ 
# | |___| | | | (_| | | | | (_| |  __/   | | | | | |  __/ | | | | |  __/ 
#  \____|_| |_|\__,_|_| |_|\__, |\___|   |_| |_| |_|\___|_| |_| |_|\___| 
#                          |___/                                         
#  
# by Stephan Raabe (2023) 
# ----------------------------------------------------- 

echo "Changing theme..."

# ----------------------------------------------------- 
# Update Wallpaper with pywal
# ----------------------------------------------------- 
wal -q -i /Arquivos/Dropbox/Wallpapers/

# ----------------------------------------------------- 
# Wait for 1 sec
# ----------------------------------------------------- 
sleep 1

# ----------------------------------------------------- 
# Reload qtile to color bar
# ----------------------------------------------------- 
qtile cmd-obj -o cmd -f reload_config

# ----------------------------------------------------- 
# Get new theme
# ----------------------------------------------------- 
source "$HOME/.cache/wal/colors.sh"
newwall=$(echo $wallpaper | sed "s|/Arquivos/Dropbox/Wallpapers/||g")

# ----------------------------------------------------- 
# Send notification
# ----------------------------------------------------- 
notify-send "Theme and Wallpaper updated" "With image $newwall"

echo "Done."