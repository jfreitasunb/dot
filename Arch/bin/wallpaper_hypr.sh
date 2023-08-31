#!/bin/bash
# use nullglob in case there are no matching files
shopt -s nullglob

# create an array with all the filer/dir inside ~/myDir
arr=(/Arquivos/Dropbox/Wallpapers/*)

#if [ "$(xrandr | grep -c 'HDMI-0 connected')" -ge 1 ]; then
#    i=$(shuf -i0-${#arr[@]} -n1)
#    j=$(shuf -i0-${#arr[@]} -n1)
#    feh --bg-fill ${arr[$i]} ${arr[$j]}
#else
#    i=$(shuf -i0-${#arr[@]} -n1)
#    feh --bg-fill ${arr[$i]}
#fi

i=$(shuf -i0-${#arr[@]} -n1)
wallpaper=${arr[$i]}
# ----------------------------------------------------- 
# Set the new wallpaper
# ----------------------------------------------------- 
swww img $wallpaper --transition-step=20 --transition-fps=20
~/.config/waybar/reload.sh

# ----------------------------------------------------- 
# Send notification
# ----------------------------------------------------- 
notify-send "Theme and Wallpaper updated" "With image $newwall"

echo "DONE!"


