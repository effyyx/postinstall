#!/bin/bash

screenshot_dir="$HOME/Pictures/Screenshots"
mkdir -p "$screenshot_dir"
screenshot_path="$screenshot_dir/$(date +'%s_grim.png')"

case "$1" in
    --fullscreen)
        grim "$screenshot_path"
        wl-copy < "$screenshot_path"
        notify-send "スクリーンショット" "$screenshot_path" --icon="$screenshot_path" -a "screenshot"
        ;;
    --region)
        grim -g "$(slurp)" "$screenshot_path"
        wl-copy < "$screenshot_path"
        notify-send "スクリーンショット" "$screenshot_path" --icon="$screenshot_path" -a "screenshot"
        ;;
    --ocr)
        tmp="/tmp/qs-ocr-$(date +'%s').png"
        grim -g "$(slurp)" "$tmp"
        if command -v manga-ocr &>/dev/null; then
            result=$(manga-ocr "$tmp" 2>/dev/null)
        elif command -v tesseract &>/dev/null; then
            result=$(tesseract "$tmp" stdout -l jpn 2>/dev/null)
        else
            notify-send "OCR エラー" "manga-ocr も tesseract も見つかりません" -a "screenshot"
            rm -f "$tmp"
            exit 1
        fi
        echo -n "$result" | wl-copy
        notify-send "OCR 完了" "$result" -a "screenshot"
        rm -f "$tmp"
        ;;
    *)
        # default: region
        grim -g "$(slurp)" "$screenshot_path"
        wl-copy < "$screenshot_path"
        notify-send "スクリーンショット" "$screenshot_path" --icon="$screenshot_path" -a "screenshot"
        ;;
esac
