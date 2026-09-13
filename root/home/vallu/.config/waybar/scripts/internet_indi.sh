#!/bin/zsh

# Perform the check
curl -s --max-time 2 -I http://google.com > /dev/null

if [[ $? -eq 0 ]]
then
    echo '{"text": "", "class": "connected", "tooltip": "Internet is up"}'
else
    echo '{"text": "<span font=\"14\" color=\"#ff9000\">\ueb01</span>", "class": "disconnected", "tooltip": "Internet is down"}'
fi
