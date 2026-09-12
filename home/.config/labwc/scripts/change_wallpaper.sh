#!/bin/zsh

# Intended to use called from MangoWC or other WMs

wallpaper_dir1="$HOME/personal/wallpapers/ennaval/"
wallpaper_dir2="$HOME/personal/wallpapers/hollow_knight/"
wallpaper_dir3="$HOME/personal/wallpapers/arch_minimal_wallpapers_full_hd/"

while true
do
    find "$wallpaper_dir1" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.webp" -o -iname "*.gif" \) | sort | while read -r selected_wallpaper
    do
        RAND_NUM=$RANDOM
        if [[ $((RAND_NUM % 2)) -eq 1 ]]
        then
            swww img --resize crop -t wipe --transition-step 3 --transition-fps 120 --transition-duration 3 --transition-angle $((RAND_NUM % 360)) "$selected_wallpaper"
        else
            swww img --resize crop -t any --transition-step 3 --transition-fps 120 --transition-duration 3 "$selected_wallpaper"
        fi

        sleep 5
    done
done
