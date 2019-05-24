#!/usr/bin/env bash


awk -F 'EventID' '{print $2}' "$1" |awk -F ',' '{print $1}' |awk '{print $NF}' |awk '$0!=""{arr[$1]++} END{for(i in arr){print "event "i": "arr[i]" times"}}'| sort -nk 2
#prints the times an event occurs
