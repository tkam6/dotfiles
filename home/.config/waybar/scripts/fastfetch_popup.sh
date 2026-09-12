#!/usr/bin/env bash

alacritty \
  --class fastfetch_popup \
  -o window.dimensions.columns=90 \
  -o window.dimensions.lines=28 \
  -o window.decorations=none \
  -e bash -lc "fastfetch; echo; read -n1 -s -r -p ''"
