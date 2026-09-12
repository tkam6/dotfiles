#!/usr/bin/env python3

import json
import sys
import socket
import subprocess
import urllib.request
import urllib.error

CHECK_URL = "http://connectivitycheck.gstatic.com/generate_204"
TIMEOUT = 5

def check_connectivity():
    try:
        req = urllib.request.Request(CHECK_URL)
        with urllib.request.urlopen(req, timeout=TIMEOUT) as response:
            if response.status == 204:
                return "full"
            else:
                return "portal"
    except urllib.error.HTTPError as e:
        # If we get redirected or weird status
        return "portal"
    except (urllib.error.URLError, socket.timeout):
        return "none"
    except Exception:
        return "unknown"


status = check_connectivity()
op = subprocess.run(
    ["nmcli", "networking", "connectivity"],
    text=True,
    capture_output=True
).stdout.strip()

# CONNECTED AND NETWORK ACCESS AVAILABLE
if status == "full":
    # WiFi icon
    text = "<span color='#00AA00'>\uf1eb</span>"
    tooltip = "Full internet access"

# CAPTIVE PORTAL
elif status == "portal":
    # WiFi icon with a lock icon
    # Contains em/en spaces!
    text = "<span color='#FFD145'>\uf1eb</span>  <span color='#FFD145' font='10'>\udb80\udf41</span>"
    tooltip = "Captive portal detected"

elif status == "none":
    # CONNECTED, BUT NO INTERNET; PORTAL CONDITION IS ALREADY CHECKED
    if op == "full":
        # WiFi icon with an exclaimation mark
        # Contains em/en spaces!
        text = "<span rise='-2000' color='#FFD145'>\uf1eb</span> <span color='#FFD145' rise='-2500' weight='800'>!</span>"
        tooltip = "No internet access"
    # DISCONNECTED
    else:
        # WiFi icon with a cross icon
        # Contains em/en spaces!
        # text = "<span color='#FFD145'>\uf1eb</span> <span rise='-1000' color='#FFD145'>\uf467</span>"

        # Satellite icon
        text = "<span font='13' rise='-2000' color='#FFD145'>\uef5f</span>"
        tooltip = "Disconnected"

# SOME PROBLEM
else:
    text = "<span color='#FF4F4F'>\uf1eb</span> <span color='#FF4F4F'>\uf128</span>"
    tooltip = "Unknown network state"

output = {
    "text": text,
    "class": status,
    "tooltip": tooltip
}

print(json.dumps(output))

