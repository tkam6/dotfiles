#!/usr/bin/env bash

# Check if Wi-Fi radio is enabled
WIFI_STATE=$(nmcli -t -f WIFI general status | cut -d: -f2)

if [[ "$WIFI_STATE" == "enabled" ]]; then
    RADIO_ICON="󰤨"
else
    RADIO_ICON="󰤭"
fi

# Connectivity status
NETWORK_CONN=$(nmcli networking connectivity)

case "$NETWORK_CONN" in
    full)
        TEXT="$RADIO_ICON Connected"
        CLASS="full"
        TOOLTIP="Full internet access"
        ;;
    portal)
        TEXT="$RADIO_ICON Portal"
        CLASS="portal"
        TOOLTIP="Captive portal detected"
        ;;
    limited)
        TEXT="$RADIO_ICON Limited"
        CLASS="limited"
        TOOLTIP="Limited connectivity"
        ;;
    none)
        TEXT="$RADIO_ICON Offline"
        CLASS="none"
        TOOLTIP="No connection"
        ;;
    *)
        TEXT="$RADIO_ICON Unknown"
        CLASS="unknown"
        TOOLTIP="Unknown state"
        ;;
esac

printf '{"text":"%s","class":"%s","tooltip":"%s"}\n' "$TEXT" "$CLASS" "$TOOLTIP"
