#!/bin/zsh
dt=$(date +%d-%m-%Y_%H.%M.%S)
fl_nm="/home/vallu/Pictures/Screenshots/clipped_$dt.png"
fl_nm_prn="clipped_$dt.png"
grim -g "$(slurp)" $fl_nm
notify-send "Captured screenshot clip $fl_nm_prn"
wl-copy "$fl_nm"
