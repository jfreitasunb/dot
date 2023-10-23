#!/usr/bin/bash
id=$(pactl list sinks short | grep "Samsung" | cut -f1)
pactl set-default-sink $id
