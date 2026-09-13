#!/usr/bin/env bash

STEP=5
DIR="$1"

if [ "$DIR" = "up" ]; then
    brightnessctl -e2 set ${STEP}%+
    CHG="❯❯"
elif [ "$DIR" = "down" ]; then
    brightnessctl -e2 --min-value=1000 set ${STEP}%-
    CHG="❮❮"
fi

BRIGHT=$(brightnessctl get)
MAX=$(brightnessctl max)
PCT=$(awk "BEGIN {print $BRIGHT/$MAX}")

swayosd-client --custom-progress "$PCT" --custom-progress-text "$CHG" --custom-icon "display-brightness-symbolic"
