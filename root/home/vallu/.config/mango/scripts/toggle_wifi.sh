#!/usr/bin/env bash
if nmcli -t -f WIFI g | grep -q enabled; then
    nmcli radio wifi off
else
    nmcli radio wifi on
fi
