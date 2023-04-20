#!/bin/bash
# use nullglob in case there are no matching files
shopt -s nullglob

# create an array with all the filer/dir inside ~/myDir
arr=(/Arquivos/Dropbox/Wallpapers/*)

if [ "$(xrandr | grep -c 'HDMI-0 connected')" -ge 1 ]; then
    i=$(shuf -i0-${#arr[@]} -n1)
    j=$(shuf -i0-${#arr[@]} -n1)
    feh --bg-fill ${arr[$i]} ${arr[$j]}
else
    i=$(shuf -i0-${#arr[@]} -n1)
    feh --bg-fill ${arr[$i]}
fi
# iterate through array using a counter
#for ((i=0; i<${#arr[@]}; i++)); do
    #do something to each element of array
#    echo "${arr[$i]}"
#done
