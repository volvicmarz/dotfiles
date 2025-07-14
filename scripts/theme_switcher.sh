#!/bin/bash

THEME="$HOME/.config/current_theme"

#default disco elysium
if [[ ! -f "$THEME" ]]; then
	echo "disco" > "$THEME"
fi

CURRENT_THEME=$(cat "$THEME")

if [[ "$CURRENT_THEME" == "disco" ]]; then
	echo "jojo" > "$THEME"
	NEW_THEME="jojo"
else
	echo "disco" > "$THEME"
	NEW_THEME="disco"
fi

#paths
WAYBAR="$HOME/.config/waybar"
HYPRLAND="$HOME/.config/hypr"
WAYBAR_THEME="$WAYBAR/themes/$NEW_THEME"
HYPRLAND_THEME="$HYPRLAND/themes/$NEW_THEME"

#symlinks
ln -sf "$WAYBAR_THEME/top.jsonc" "$WAYBAR/top.jsonc"
ln -sf "$WAYBAR_THEME/theme.css" "$WAYBAR/theme.css"
ln -sf "$WAYBAR_THEME/top.css" "$WAYBAR/top.css"
ln -sf "$HYPRLAND_THEME/theme.conf" "$HYPRLAND/theme.conf"
ln -sf "$HYPRLAND_THEME/hyprpaper.conf" "$HYPRLAND/hyprpaper.conf"

#restarting todos

pkill waybar
waybar --config "$WAYBAR/top.json" --style "$WAYBAR/theme.css"
hyprctl reload 
pkill hyprpaper
hyprpaper &


notify-send "Theme switched to: $NEW_THEME"
