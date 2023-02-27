#!/usr/bin/bash
id=$(pactl list sinks short | grep "Logitech_USB_Headset" | cut -f1)
pactl set-default-sink $id