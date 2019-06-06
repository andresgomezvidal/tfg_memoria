#!/usr/bin/env bash

for i in *; do if [[ ! "$i" =~ ".pdf" && ! "$i" =~ ".sh" && -z "$(grep $i -R ../capitulos/*.tex)" ]]; then echo "$i"; fi  ; done
