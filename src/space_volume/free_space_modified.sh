#!/usr/bin/env bash

alert=$5
FILE="$(grep '"id":"'$alert'"' /var/ossec/logs/archives/archives.json |grep -Eoh '"path":"/var/log/ossec-custom/[a-zA-Z0-9._-]+"' |tail -1 |awk -F ':' '{gsub("\"","",$2); print $2}')"
value="$(head -1 "$FILE")"
change_status="$(tail -1 "$FILE")"
if ! [[ "$change_status" =~ 'modified' || "$change_status" =~ 'safe' ]]; then
	exit 1
fi
if [[ "$change_status" =~ 'modified' ]]; then
	echo "$value" > "$FILE"
	echo "safe" >> "$FILE"
fi
