#!/usr/bin/env python3
import subprocess
import time
import json

INIT_DELAY = 1.0
MAX_LEN = 40
SLEEP = 0.3

def get_title():
    try:
        out = subprocess.check_output(["mmsg", "-g", "-c"], text=True)
        for line in out.splitlines():
            if "title" in line:
                return line.split(" ", 2)[2]
    except Exception:
        return ""
    return ""

def scroll_text(text, pos):
    if len(text) <= MAX_LEN:
        return text
    padded = text + "   " + text
    return padded[pos:pos + MAX_LEN]

pos = 0

while True:
    title = get_title() + "        "

    if not title:
        print(json.dumps({"text": ""}), flush=True)
        time.sleep(SLEEP)
        continue

    if len(title) <= MAX_LEN:
        output = title
    else:
        pos = (pos + 1) % len(title)
        output = scroll_text(title, pos)

    print(json.dumps({"text": output}), flush=True)
    time.sleep(SLEEP)
