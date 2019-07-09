#!/usr/bin/env bash

alert=$5
nvalue="$(grep '"id":"'$alert'"' /var/ossec/logs/archives/archives.json |grep -Eoh '"Total_of_free_bytes":"\w+"' |tail -1 |awk -F ':' '{gsub("\"","",$2); print $2}')"
ip="10.0.3.2"
volume="F"
script_filename="$(basename "$(test -L "$0" && readlink "$0" || echo "$0")")"
DIR="/var/log/ossec-custom/"
FILE="$DIR/ossec_windows-agent-${ip}_volume-${volume}_free-space"
mkdir -p "$DIR"

if ! [[ "$nvalue" =~ ^-?[.0-9]+$ ]]; then
	exit 1
fi
if [ -s "$FILE" ]; then
	value="$(head -1 "$FILE")"
	if ! [[ "$value" =~ ^-?[.0-9]+$ ]]; then
		value=0
	fi
else
	value=0
fi

if [[ $value -gt 0 && $(awk 'BEGIN {print ('$nvalue' > '$value')}') -eq 1 ]]; then
	echo "$nvalue" > "$FILE"
	echo "modified" >> "$FILE"
elif [[ $value -eq 0 || "$nvalue" -lt "$value" ]]; then
	echo "$nvalue" > "$FILE"
	echo "safe" >> "$FILE"
fi
