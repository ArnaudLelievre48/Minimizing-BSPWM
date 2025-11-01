#!/bin/bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# Use first argument as WID, or default to first window on "hidden"
wid=${1:-$(bspc query -N -n any.leaf.window -d hidden | head -n 1)}
[ -z "$wid" ] && exit 1

rm "$SCRIPT_DIR/thumbnails/$wid.png"

# Float and center
bspc node "$wid" -t floating;
bspc node "$wid" -d focused;
bspc node "$wid" -g hidden=off;

eval "$(bspc query -T -m | jq -r '.rectangle | "x=\(.x) y=\(.y) w=\(.width) h=\(.height)"')" && pos_x=$(( x + (w / 2) - 100 )) && pos_y=$((y + (h / 2) -500 ))

xdotool windowmove "$wid" "$pos_x" "$pos_y";
sleep 0.2

pos_x_=$(($pos_x - 200));
pos_y_=$(($pos_y + 100));
xdotool windowsize "$wid" 600 800;
xdotool windowmove "$wid" "$((pos_x_))" "$((pos_y_))";
sleep 0.2
 
bspc node "$wid" -t tiled -f
