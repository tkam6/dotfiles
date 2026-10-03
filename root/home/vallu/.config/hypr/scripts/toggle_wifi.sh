#!/usr/bin/env sh
status=$(nmcli radio wifi)
if [ "$status" = "enabled" ]; then
    nmcli radio wifi off
elif [ "$status" = "disabled" ]; then
    nmcli radio wifi on
fi
