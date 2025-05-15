#! /bin/bash -x

if [ "$(cat /proc/acpi/button/lid/LID/state | grep -c close)" -ge 1 ]; then
    if ["$(cat /sys/class/power_supply/BAT0/status | grep -c Discharging)" -ge 1]; then
        systemctl suspend-then-hibernate
    fi
fi
