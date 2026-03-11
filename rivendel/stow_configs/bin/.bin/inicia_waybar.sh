#!/bin/bash

killall waybar

# Verifica se a saída do comando 'hyprctl monitors' contém "HDMI" ou "DP"
if hyprctl monitors | grep -q -E "(HDMI|eDP)-"; then
    waybar -c ~/.config/waybar/config-monitor-interno.json &
    waybar -c ~/.config/waybar/config-monitor-externo.json &
else
    waybar -c ~/.config/waybar/config-monitor-interno.json &
fi
