#!/bin/bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

mkdir -p "$SCRIPT_DIR/thumbnails"

wid=${1:-$(bspc query -N -n focused)}
[ -z "$wid" ] && exit 1

# Float and center
maim -i $wid "$SCRIPT_DIR/thumbnails/$wid.png";
sleep 0.05;

bspc node "$wid" -t floating;
xdotool windowsize "$wid" 600 800;

eval "$(bspc query -T -m | jq -r '.rectangle | "x=\(.x) y=\(.y) w=\(.width) h=\(.height)"')" && pos_x=$(( x + (w / 2) - 300 )) && pos_y=$((y + (h / 2) - 400 ))

xdotool windowmove "$wid" "$pos_x" "$pos_y";
sleep 0.2
xdotool windowsize "$wid" 200 1000;
xdotool windowmove "$wid" "$((pos_x+100))" -1000;

sleep 0.2
bspc node "$wid" -g hidden=on
bspc node "$wid" -t tiled
