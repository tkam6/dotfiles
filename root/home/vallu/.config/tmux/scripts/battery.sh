#!/bin/sh
# Heavily modified from https://raw.github.com/richo/battery/master/bin/battery
GREY='#[fg=grey]'
RED='#[fg=red]'
YELLOW='#[fg=yellow]'
GREEN='#[fg=green]'
RESET='#[default]'

battery_status()
{
    BATTERIES=$(ls /sys/class/power_supply | grep BAT)
    BAT_COUNT=$(ls /sys/class/power_supply | grep BAT | wc -l)
    for BATTERY in $BATTERIES; do
        BAT_PATH=/sys/class/power_supply/$BATTERY
        STATUS_TXT=$(cat $BAT_PATH/status)
        case "$STATUS_TXT" in
            "Charging")     ICON="+" ;;
            "Discharging")  ICON="-" ;;
            "Full")         ICON="=" ;;
            "Not charging") ICON="~" ;;
            *)              ICON="?" ;;
        esac
        # my IdeaPad has it in the form "energy_..." It can also be like
        # "charge_...", or simply "capacity"... "capacity" just gives the
        # percentage itself, I think
        BAT_PERCENT=$(( 100 * $(cat $BAT_PATH/energy_now) / $(cat $BAT_PATH/energy_full) ))
        BAT_TOTAL=$(( ${BAT_TOTAL-0} + $BAT_PERCENT ))

        # add colour, and if needed battery level indicators
        COLOUR=$GREEN
        # add an exclaimation mark if battery is less than 40%
        if [[ "$BAT_TOTAL" -lt "40" ]]; then
            ICON="!$ICON"
            COLOUR=$RED
        elif [[ "$BAT_TOTAL" -lt "80" ]]; then
            COLOUR=$YELLOW
        fi
    done
    echo "$GREY$ICON$COLOUR$(( $BAT_TOTAL / $BAT_COUNT ))%$RESET"
}

BATTERY_STATUS_W_PERC_SIGN=`battery_status $1`
[ -z "$BATTERY_STATUS_W_PERC_SIGN" ] && exit
echo "${BATTERY_STATUS_W_PERC_SIGN}"
