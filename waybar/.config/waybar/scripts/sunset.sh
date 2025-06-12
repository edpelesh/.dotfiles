#!/usr/bin/env bash

STATE_FILE="/tmp/hyprsunset_state"
TEMP_FILE="/tmp/hyprsunset_temp"
MIN_TEMP=1200
MAX_TEMP=6500
STEP=100

load_state() {
	[[ -f "$STATE_FILE" ]] && cat "$STATE_FILE" || echo "custom"
}

save_state() {
	echo "$1" > "$STATE_FILE"
}

load_temp() {
	[[ -f "$TEMP_FILE" ]] && cat "$TEMP_FILE" || echo "$MAX_TEMP"
}

save_temp() {
	echo "$1" > "$TEMP_FILE"
}

set_temp() {
	hyprctl hyprsunset temperature "$1" &>/dev/null
	save_temp "$1"
}

set_identity() {
	hyprctl hyprsunset identity &>/dev/null
	save_temp "$MAX_TEMP"
}

update_output() {
	local mode="$1"
	local temp="$2"
	local icon

	case "$mode" in
		night) icon="󰖔" ;;   # Night
		day) icon="󰖙" ;;     # Day
		custom) icon="󰪥" ;;  # Custom
	esac

	local bar_len=10
	local temp_percent=$(( (temp - MIN_TEMP) * bar_len / (MAX_TEMP - MIN_TEMP) ))
	(( temp_percent < 0 )) && temp_percent=0
	(( temp_percent > bar_len )) && temp_percent=$bar_len
	local progress=$(printf '%*s' "$temp_percent" '' | tr ' ' '█')
	progress=$(printf '%-*s' "$bar_len" "$progress" | tr ' ' '░')

	jq -nc --arg icon "$icon" --arg mode "$mode" --arg temp "$temp" --arg progress "$progress" \
		'{"text": $icon}'
#		'{"text": $icon, "tooltip": "Mode: \($mode)\nTemp: \($temp)K\n[\($progress)]"}'
}

case "$1" in
	click)
		current_mode=$(load_state)
		if [ "$current_mode" = "night" ]; then
			set_identity
			save_state "day"
			update_output "day" "$MAX_TEMP"
		else
			set_temp 2500
			save_state "night"
			update_output "night" "2500"
		fi
		;;
	scroll-up)
		temp=$(load_temp)
		new_temp=$((temp + STEP))
		(( new_temp > MAX_TEMP )) && new_temp=$MAX_TEMP
		set_temp "$new_temp"
		save_state "custom"
		update_output "custom" "$new_temp"
		;;
	scroll-down)
		temp=$(load_temp)
		new_temp=$((temp - STEP))
		(( new_temp < MIN_TEMP )) && new_temp=$MIN_TEMP
		set_temp "$new_temp"
		save_state "custom"
		update_output "custom" "$new_temp"
		;;
	*)
		mode=$(load_state)
		temp=$(load_temp)
		update_output "$mode" "$temp"
		;;
esac
