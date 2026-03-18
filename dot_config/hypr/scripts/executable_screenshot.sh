#!/bin/bash

# Take a screenshot
screenshot_path="$HOME/Pictures/Screenshots/$(date +'%s_grim.png')"
grim -g "$(slurp)" "$screenshot_path"

# Copy the screenshot to the clipboard
wl-copy <"$screenshot_path"

dunstify "Screenshot saved to clipboard" "$screenshot_path" --icon="$screenshot_path"
