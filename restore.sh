#!/bin/bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

# Use first argument as WID, or default to first window on "hidden"
wid=${1:-$(bspc query -N -n any.leaf.window -d hidden | head -n 1)}
[ -z "$wid" ] && exit 1

rm "$SCRIPT_DIR/thumbnails/$wid.png"

monitor=$(bspc query -T -m focused)
mon_w=$(echo "$monitor" | jq '.rectangle.width')
mon_h=$(echo "$monitor" | jq '.rectangle.height')

# Float and center
bspc node "$wid" -t floating;
bspc node "$wid" -g hidden=off

pos_x=$(($mon_w/2 - 100))
pos_y=$(($mon_h/2 - 500))
xdotool windowmove "$wid" "$pos_x" "$pos_y";
sleep 0.2
pos_x_=$(($mon_w/2 - 300));
pos_y_=$(($mon_h/2 - 400));
xdotool windowsize "$wid" 600 800;
xdotool windowmove "$wid" "$((pos_x_))" "$((pos_y_))";
sleep 0.2
 
bspc node "$wid" -t tiled -f
