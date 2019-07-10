#!/usr/bin/env bash

alert=$5
line="$(awk '/"id":"'$alert'"/{last=$0}; END{print last}' /var/ossec/logs/archives/archives.json)"
nvalue="$(grep -Eoh '"Total_of_free_bytes":"\w+"' <<< "$line" |awk -F ':' '{gsub("\"","",$2); print $2}')"
ip="$(grep -Eoh '"ip":"[0-9]+.[0-9]+.[0-9]+.[0-9]+"' <<< "$line" |awk -F ':' '{gsub("\"","",$2); print $2}')"
volume="$(grep -Eoh '"backup_volume":"\w+"' <<< "$line" |awk -F ':' '{gsub("\"","",$2); print $2}')"
script_filename="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
DIR="/var/log/ossec-custom/"
FILE="$DIR/ossec_windows-agent-${ip}_volume-${volume}_free-space"
LOG="$DIR/events.log"
mkdir -p "$DIR"

if ! [[ "$nvalue" =~ ^-?[.0-9]+$ ]]; then
	exit 1
fi

if [ -s "$FILE" ]; then
	value="$(cat "$FILE")"
	if ! [[ "$value" =~ ^-?[.0-9]+$ ]]; then
		value=0
	fi
else
	value=0
fi

if [[ $value -gt 0 && $(awk 'BEGIN {print ('$nvalue' > '$value')}') -eq 1 ]]; then
	echo "$nvalue" > "$FILE"
	echo "{\"original_alert\":\"$alert\", \"new_value\":\"$nvalue\", \"previous_value\":\"$value\", \"source_ip\":\"$ip\", \"backup_volume\":\"$volume\", \"storage_file\":\"$FILE\"}" >> "$LOG"
elif [[ $value -eq 0 || "$nvalue" -lt "$value" ]]; then
	echo "$nvalue" > "$FILE"
fi