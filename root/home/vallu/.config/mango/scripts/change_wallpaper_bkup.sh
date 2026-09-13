#!/bin/zsh

# Intended to use called from MangoWC or other WMs

wallpaper_dir1="$HOME/personal/wallpapers/ennaval/"
wallpaper_dir2="$HOME/personal/wallpapers/hk/"
wallpaper_dir3="$HOME/personal/wallpapers/arch_minimal/"
wallpapers=("${(@f)$(find "$wallpaper_dir1" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" -o -iname "*.webp" -o -iname "*.gif" \) | sort)}")

while true
do
    for selected_wallpaper in "${wallpapers[@]}"
    do
        # Command with all parameters
        # This one doesn't need them as I've specified environment variables in Mango
        # awww img --resize crop -t any --transition-step 3 --transition-fps 120 --transition-duration 3 "$selected_wallpaper"

        RAND_NUM=$RANDOM
        if [[ $((RAND_NUM % 2)) -eq 1 ]]
        then
            awww img --resize crop -t wipe --transition-angle $((RAND_NUM % 360)) "$selected_wallpaper" 
        else
            awww img --resize crop -t any "$selected_wallpaper"
        fi

        power_profile=$(powerprofilesctl get)
        if [[ $power_profile == "power-saver" ]]
        then
            sleep 1m
        elif [[ $power_profile == "balanced" ]]
        then
            sleep 1m
        else
            sleep 10
        fi
    done
done

# awww img --resize crop -t any "/home/vallu/personal/wallpapers/arch/i_use_arch_btw.webp"
