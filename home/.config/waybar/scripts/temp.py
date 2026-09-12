#!/usr/bin/env python3
import time
import json

ZONE = "/sys/class/thermal/thermal_zone7/temp"
SLEEP = 3

while True:
    try:
        with open(ZONE) as f:
            temp = int(f.read().strip()) // 1000
        if temp < 60:
            icon = "\uf2ca"
            colour = "#00AA00"
        elif temp < 80:
            icon = "\uf2c9"
            colour = "#FF8B00"
        else:
            icon = "\uf2c7"
            colour = "#FF1500"
        text = f"<span font='13' color='{colour}'>{icon}</span> {temp}°C"
    except Exception:
        text = "N/A"

    print(json.dumps({"text": text}), flush=True)
    time.sleep(SLEEP)
