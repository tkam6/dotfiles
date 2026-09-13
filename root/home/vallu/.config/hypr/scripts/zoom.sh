#!/usr/bin/env sh
if [ -z "$1" ]; then exit 1; fi
cur_zoom=$(hyprctl getoption cursor:zoom_factor | awk '/float:/ {print $2}')
new_zoom=$(awk "BEGIN {z = $cur_zoom $1 1; if (z < 1) z = 1; print z}")
exec hyprctl eval "hl.config({ [\"cursor.zoom_factor\"] = $new_zoom })"
