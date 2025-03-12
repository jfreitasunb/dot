#! /bin/bash

if [ "$(cat /proc/acpi/button/lid/LID/state | grep -c close)" -ge 1 ]; then
    systemctl hibernate
fi
