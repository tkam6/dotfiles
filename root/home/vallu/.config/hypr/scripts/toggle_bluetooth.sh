#!/usr/bin/env sh
status=$(bluetoothctl show | grep -oE 'Powered: .+' | grep -oE 'yes|no')
if [ "$status" == "yes" ]; then
    bluetoothctl power off
elif [ "$status" == "no" ]; then
    bluetoothctl power on
fi
