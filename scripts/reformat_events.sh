#!/usr/bin/env bash

if [ -z "$1" ]; then
	exit 1
fi

TARGET="$1"_simplified

#-F to avoid problems with space in regex

awk -F '|' '
function del_from_to_next(target, from, to, before, after, nstr){
	ifrom=index(target,from)-before
	subtarget=substr(target, ifrom, length(target)-ifrom)
	str=substr(target, ifrom, index(subtarget, to) -before-after)
	if(ifrom>0 && subtarget!="" && str!="" && index(subtarget, to)-before-after>0){
		gsub(str, nstr, $0)
	}
}

$0!~/->EventChannel/ { print }
$0~/->EventChannel/{
	nbefore=0; nafter=0;
	#leave time, ip, EventChannel info
	split($0,arr_s," ")
	split($0,arr_e,"->EventChannel")
	c=split(arr_e[1],arr_z," ")
	$0=arr_s[4]" "arr_z[c]" "arr_e[2]
	gsub("\""," ",$0)

	del_from_to_next($0, " ProviderGuid :", ",", nbefore, nafter, "")
	del_from_to_next($0, " Version :", ",", nbefore, nafter, "")
	del_from_to_next($0, " Opcode :", ",", nbefore, nafter, "")
	del_from_to_next($0, " SystemTime :", ",", nbefore, nafter, "")
	del_from_to_next($0, " EventRecordID :", ",", nbefore, nafter, "")
	del_from_to_next($0, " Channel :", ",", nbefore, nafter, "")
	del_from_to_next($0, " Computer :", ",", nbefore, nafter, "")
	del_from_to_next($0, " RuleName :", ",", nbefore, nafter, "")
	del_from_to_next($0, " UtcTime :", ",", nbefore, nafter, "")
	del_from_to_next($0, " ProcessGuid :", ",", nbefore, nafter, "")
	del_from_to_next($0, " Keywords :", ",", nbefore, nafter, "")
	del_from_to_next($0, " Level :", ",", nbefore, nafter, "")
	del_from_to_next($0, " SeverityValue :", ",", nbefore, nafter, "")
	del_from_to_next($0, " CreationUtcTime :", "}", 2, nafter, "")

	print $0
}
' "$1" > "$TARGET"

./count_events.sh "$TARGET"
