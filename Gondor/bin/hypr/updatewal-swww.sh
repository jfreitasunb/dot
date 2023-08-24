#!/bin/bash -x
# ----------------------------------------------------- 
# Set the new wallpaper
# ----------------------------------------------------- 
#swww img $wallpaper --transition-step=20 --transition-fps=20
#~/.config/waybar/reload.sh

# ----------------------------------------------------- 
# Send notification
# ----------------------------------------------------- 
notify-send "Theme and Wallpaper updated" "With image $newwall"

echo "DONE!"
