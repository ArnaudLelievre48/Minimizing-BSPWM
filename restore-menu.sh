#!/bin/bash

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

echo "$SCRIPT_DIR"

THUMB_DIR="$SCRIPT_DIR/thumbnails"
RESTORE_SCRIPT="$SCRIPT_DIR/restore.sh"
THEME="$SCRIPT_DIR/style_thumbnail.rasi"

list_index=()
entries=""
k=0

# Build the list of thumbnails and names
for A in "$THUMB_DIR"/*; do
    [ -f "$A" ] || continue
    wid=$(basename "$A" .png)

    # get window name using xprop
    window_name=$(xprop -id "$wid" WM_NAME 2>/dev/null | cut -d '"' -f2)
    [ -z "$window_name" ] && window_name="$wid"

    entries+="$k ~ $window_name\x00icon\x1f$A\n"
    list_index+=("$wid")
    ((k++))
done

monitor_name="$(bspc query -M -m focused --names)";
# Show in Rofi
window=$(printf "%b" "$entries" | rofi -m $monitor_name -dmenu -show-icons -theme "$THEME" -p "Hidden Windows:")

[ -z "$window" ] && exit 0

# Extract index (before '~')
index="${window%% *}"
wid="${list_index[$index]}"

echo "Selected window id: $wid"

# Restore it
"$RESTORE_SCRIPT" "$wid"

