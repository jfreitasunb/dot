#!/usr/bin/env bash

echo 'Updating Applications...'
    sudo aura -Syu
    sudo aura -Au

#echo ' '
#echo 'Cleaning caches & directories...'
#    pacman -Sc
#   paru -Sc

echo ' '

xmonad --recompile

echo 'Updating Complete!'
