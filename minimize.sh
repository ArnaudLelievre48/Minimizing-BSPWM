#!/bin/bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

wid=${1:-$(bspc query -N -n focused)}
[ -z "$wid" ] && exit 1


monitor=$(bspc query -T -m focused)
mon_w=$(echo "$monitor" | jq '.rectangle.width')
mon_h=$(echo "$monitor" | jq '.rectangle.height')


window=$(bspc query -N -n focused)
win_x=$(echo "$monitor" | jq '.rectangle.x')
win_y=$(echo "$monitor" | jq '.rectangle.y')
win_w=$(echo "$monitor" | jq '.rectangle.width')
win_h=$(echo "$monitor" | jq '.rectangle.height')

# Float and center
maim -i $wid "$SCRIPT_DIR/thumbnails/$wid.png";
sleep 0.05;

bspc node "$wid" -t floating;
xdotool windowsize "$wid" 600 800;


pos_x=$(($mon_w/2 - 300))
pos_y=$(($mon_h/2 - 400))
xdotool windowmove "$wid" "$pos_x" "$pos_y";
sleep 0.2
xdotool windowsize "$wid" 200 1000;
xdotool windowmove "$wid" "$((pos_x+100))" -1000;

sleep 0.2
bspc node "$wid" -d hidden
bspc node "$wid" -t tiled
