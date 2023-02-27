#!/usr/bin/bash
id=$(pactl list sinks short | grep "pci-0000_00_1f" | cut -f1)
pactl set-default-sink $id
