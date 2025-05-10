#!/bin/bash

while true; do

    PIC=($(find ~/OneDrive/Pictures/Wallpapers -type f | shuf -n 2 --random-source=/dev/random))

    swaymsg output "eDP-1" bg "${PIC[0]}" fill >/dev/null
    swaymsg output "HDMI-A-1" bg "${PIC[1]}" fill >/dev/null

    sleep 120m

done
