#!/bin/bash

RYZENADJ="/usr/local/bin/ryzenadj"
INTERVAL=5
LASTKNOWN=""
MONITOR=eDP-1
PERFORMANCE_MW=37000
PERFORMANCE_MODE=2560x1600@165.000
BALANCED_MW=22000
BALANCED_MODE=2560x1600@60.000
POWERSAVE_MW=15000
POWERSAVE_MODE=2560x1600@60.000

while :
do
	CURPP="`powerprofilesctl get`"

	if [ "$CURPP" != "$LASTKNOWN" ]; then
		LASTKNOWN=$CURPP

		if [ "$CURPP" == "performance" ]; then
			echo "performance"
			sudo $RYZENADJ --stapm-limit=$PERFORMANCE_MW --fast-limit=$PERFORMANCE_MW --slow-limit=$PERFORMANCE_MW --apu-slow-limit=$PERFORMANCE_MW
			gnome-randr modify --mode $PERFORMANCE_MODE $MONITOR
		elif [ "$CURPP" == "power-saver" ]; then
			echo "power-save"
			sudo $RYZENADJ --stapm-limit=15000 --fast-limit=15000 --slow-limit=15000 --apu-slow-limit=15000
			gnome-randr modify --mode $POWERSAVE_MODE $MONITOR
		else
			if on_ac_power; then
				echo "performance"
				sudo $RYZENADJ --stapm-limit=$PERFORMANCE_MW --fast-limit=$PERFORMANCE_MW --slow-limit=$PERFORMANCE_MW --apu-slow-limit=$PERFORMANCE_MW
				gnome-randr modify --mode $PERFORMANCE_MODE $MONITOR
			else
				echo "balanced"
				sudo $RYZENADJ --stapm-limit=22000 --fast-limit=22000 --slow-limit=22000 --apu-slow-limit=22000
				gnome-randr modify --mode $BALANCED_MODE $MONITOR
			fi
		fi
	fi

	sleep $INTERVAL
done
