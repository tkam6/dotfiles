#!/usr/bin/env bash

STEP=5
DIR="$1"

if [ "$DIR" = "up" ]; then
    wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ "${STEP}%+"
    CHG="❯❯"
elif [ "$DIR" = "down" ]; then
    wpctl set-volume @DEFAULT_AUDIO_SINK@ "${STEP}%-"
    CHG="❮❮"
elif [ "$DIR" = "mute" ]; then
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
    CHG="--"
else
    exit 1
fi

VOL_OSD=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -oE '[0-9]+\.[0-9]+')
VOL=$(printf "%.0f" "$(echo "$VOL_OSD * 100" | bc -l)")
MUTED=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -c MUTED)
ICON="audio-volume-high-symbolic"
swayosd-client --custom-progress "$VOL_OSD" --custom-icon "$ICON" --custom-progress-text "$CHG"
