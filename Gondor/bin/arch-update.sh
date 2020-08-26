#!/usr/bin/env bash

echo 'Updating Applications...'
    sudo pacman -Syyu
    yay -Syyu

echo ' '
echo 'Cleaning caches & directories...'
    pacman -Sc
    yay -Sc

echo ' '
echo 'Updating Complete!'
