#!/bin/bash

declare -A commands=(
    ["⏻ Shutdown"]="systemctl poweroff"
    ["󰜉 Restart"]="systemctl reboot"
    ["󰗽 Logout"]="i3 exit"
    [" Lock"]="i3lock"
    ["⏾ Suspend"]="systemctl suspend"
)

options=("${!commands[@]}")

choice=$(printf '%s\n' "${options[@]}" | rofi -dmenu -p "Power" -theme ~/.config/rofi/powermenu.rasi)

if [[ -n "$choice" && -n "${commands[$choice]}" ]]; then
    eval "${commands[$choice]}"
fi
