#!/usr/bin/env bash

id=$4
alert=$5
ip=$(cut -d '-' -f1 <<< "$7")
current_timestamp=$(date '+%FT%T.%N%z')
script_filename="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
DIR="/var/log/ossec-custom/"
LOG="$DIR/events.log"
mkdir -p "$DIR"

if [ "$alert" = '300301' ]; then
	DLL=WinSCard.dll
elif [ "$alert" = '300302' ]; then
	DLL=cryptdll.dll
elif [ "$alert" = '300303' ]; then
	DLL=samlib.dll
elif [ "$alert" = '300304' ]; then
	DLL=hid.dll
elif [ "$alert" = '300305' ]; then
	DLL=vaultcli.dll
fi

output="{\"current_timestamp\":\"$current_timestamp\", \"original_alert\":\"$alert\", \"source_ip\":\"$ip\", \"imageLoaded\":\"$DLL\", \"previous_id\":\"$id\", \"script_filename\":\"$script_filename\"}"
echo "$output" >> "$LOG"
echo "$output" >> "$LOG"
