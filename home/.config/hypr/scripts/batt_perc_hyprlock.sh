#!/bin/sh

op=$(upower -b)
chrg=$(echo "$op" | grep -oE "state:\s+(dis)*charging" | grep -oE "(dis)*charging")
perc=$(echo "$op" | grep -oE "percentage:\s+[0-9]+%" | grep -oE "[0-9]+%")

if [ "$chrg" = "charging" ]; then
    perc="<span font='24' rise='-2500'>󱐋</span> $perc"
fi

echo "$perc"
