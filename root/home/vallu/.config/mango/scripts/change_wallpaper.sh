#!/bin/zsh

setopt EXTENDED_GLOB

wp_dir1="/e/en_azaghi/ennaval/"
wp_dir2="$HOME/personal/wallpapers/hk/"
wp_dir3="$HOME/personal/wallpapers/arch/arch_minimal/"
wp_dir4="$HOME/personal/wallpapers/arch/jokes/"

# ZSH ZORINS!
fl_lst=(
    "$wp_dir4"/**/*.(#i)(jpg|png|jpeg|webp|gif)(N)
)
# Shuffled
wps=($(shuf -e "${fl_lst[@]}"))
# Same order, reversed
# wps=("${(@Oa)fl_lst}")

# BASH BOYS!
# file_list=$(
#     find "$wp_dir4" \
#         -type f \
#         \( -iname "*.jpg" \
#         -o -iname "*.png" \
#         -o -iname "*.jpeg" \
#         -o -iname "*.webp" \
#         -o -iname "*.gif" \)
# )
# wps=("${(@f)$(printf '%s\n' "$file_list" | shuf)}")

while true
do
    for seld_wp in "${wps[@]}"
    do
        if (( RANDOM % 2 ))
        then
            awww img --resize crop -t wipe --transition-angle $((RANDOM % 360)) "$seld_wp"
        else
            awww img --resize crop -t any "$seld_wp"
        fi
        pwr_prof=$(powerprofilesctl get)
        case "$pwr_prof" in
            power-saver) sleep 10m ;;
            balanced)    sleep 5m  ;;
            performance) sleep 2m  ;;
            *)           sleep 7m  ;;
        esac
        # sleep 5
    done
done

# awww img --resize crop -t any "/home/vallu/personal/wallpapers/arch/jokes/i_use_arch_btw.webp"
