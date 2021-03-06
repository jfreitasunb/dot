#!/usr/bin/env bash

echo 'Updating Applications...'
    sudo pacman -Syu
    paru -Syu

echo ' '
echo 'Cleaning caches & directories...'
    pacman -Sc
    paru -Sc

echo ' '

xmonad --recompile

echo 'Updating Complete!'