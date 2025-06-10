#!/bin/sh -x
if [ "$(xrandr | grep -c 'HDMI-1 connected')" -ge 1 ]; then
    xrandr --output HDMI-1 --primary --mode 1920x1080 --pos 1596x0 --rotate normal --output DVI-I-1 --mode 1600x900 --pos 0x0 --rotate normal --output VGA-1 --off
fi
