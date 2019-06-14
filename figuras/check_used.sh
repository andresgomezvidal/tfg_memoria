#!/usr/bin/env bash

for i in *; do if [[ ! "$i" =~ ".pdf" && ! -s ${i//_rotated/} && ! "$i" =~ ".sh" && -z "$(grep $i -R ../capitulos/*.tex)" ]]; then echo "$i"; fi  ; done
