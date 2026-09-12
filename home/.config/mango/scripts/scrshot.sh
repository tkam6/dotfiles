#!/bin/zsh
dt=$(date +%d-%m-%Y_%H.%M.%S)
fl_nm="/home/vallu/Pictures/Screenshots/scrshot_$dt.png"
fl_nm_prn="scrshot_$dt.png"
grim $fl_nm
notify-send "Captured screenshot $fl_nm_prn"
wl-copy "$fl_nm"
