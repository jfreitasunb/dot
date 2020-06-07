#!/usr/bin/env bash

echo 'Updating Applications...'
    sudo pacman -Syu
    yay -Syu

echo ' ' 
echo 'Cleaning caches & directories...'
    pacman -Sc
    yay -Sc

echo ' ' 
echo 'Updating Complete!'