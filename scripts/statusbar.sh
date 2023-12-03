#!/bin/bash

bat() {
	perc=$(cat /sys/class/power_supply/BAT1/capacity)
	status=$(cat /sys/class/power_supply/BAT1/status)
	if [[ $status != "Discharging" ]]; then
		echo "󰂄 $perc%"
	else
		echo "󰁹 $perc%"
	fi
}

timing() {
	clock=$(date +%H:%M)	
	calendar=$(date +"%d-%m(%a)")
	echo "󰃰 $calendar $clock"
}

volume() {
	muted=$(pactl list sinks | awk '/Mute:/ { print $2 }' | head -n 1)
	vol=$(pactl list sinks | grep Volume: | awk 'FNR == 1 { print $5 }' | cut -f1 -d '%')

	if [ "$muted" = "yes" ]; then
		echo " muted"
	else
		echo " $vol%"	
	fi

}

network() {
	conntype=$(ip route | awk '/default/ { print substr($5,1,1) }')

	if [ -z "$conntype" ]; then
		echo "󰤭 down"
	elif [ "$conntype" = "w" ]; then
		echo "󰤨 up"
	else
		echo "󰈀 up"
	fi
}

while true; do
	xsetroot -name " [$(network)] [$(volume)] [$(bat)] [$(timing)]"
	sleep .5s
done
