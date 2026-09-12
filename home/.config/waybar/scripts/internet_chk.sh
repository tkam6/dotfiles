#!/usr/bin/env bash

TARGET="1.1.1.1"

if curl -s --max-time 2 https://1.1.1.1 >/dev/null >/dev/null 2>&1; then
    echo '{"text":"<span color=\"#00aa00\"></span>","tooltip":"Internet: Connected"}'
else
    echo '{"text":"<span color=\"#ff5000\"></span>","tooltip":"Internet: No connectivity"}'
fi
