#!/bin/sh

if [ "$(cat /sys/class/leds/input4::capslock/brightness)" = "1" ]
then
    caps="<span font='28' color='#ff0000'>󰯱</span>"
fi

if [ "$(cat /sys/class/leds/input4::numlock/brightness)" = "1" ]
then
    num="<span font='28' color='#00ff00'>󰰒</span>"
fi

echo $caps $num $1
