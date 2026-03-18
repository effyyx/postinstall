#!/bin/bash
CURRENT=$(hyprctl getoption decoration:active_opacity -j | jq -r '.float')
CURRENT_INT=$(echo $CURRENT | cut -d'.' -f1)

if [ "$CURRENT_INT" -ge 1 ]; then
    hyprctl keyword decoration:active_opacity 0.8
    hyprctl keyword decoration:inactive_opacity 0.7
else
    hyprctl keyword decoration:active_opacity 1.0
    hyprctl keyword decoration:inactive_opacity 1.0
fi
