#!/usr/bin/env bash

STATE_FILE="/tmp/hyprsunset_state"
TEMP_FILE="/tmp/hyprsunset_temp"
MIN_TEMP=1200
MAX_TEMP=6500
STEP=100

get_temp() {
	hyprsunset get | grep temperature | awk '{print int($2)}'
}

set_temp() {
	hyprsunset set temperature "$1"
	echo "$1" > "$TEMP_FILE"
}

save_state() {
	echo "$1" > "$STATE_FILE"
}

load_state() {
	[[ -f "$STATE_FILE" ]] && cat "$STATE_FILE" || echo "custom"
}

update_output() {
	local mode="$1"
	local temp="$2"
	local icon

	case "$mode" in
		night) icon="󰖔" ;;
		day) icon="󰖙" ;;
		custom) icon="󰪥" ;;
	esac

	local bar_len=10
	local temp_percent=$(( (temp - MIN_TEMP) * bar_len / (MAX_TEMP - MIN_TEMP) ))
	local progress=$(printf '%*s' "$temp_percent" '' | tr ' ' '█')
	progress=$(printf '%-10s' "$progress" | tr ' ' '░')

	jq -nc --arg icon "$icon" --arg mode "$mode" --arg temp "$temp" --arg progress "$progress" \
		'{"text": $icon, "tooltip": "Mode: \($mode)\nTemp: \($temp)K\n[\($progress)]"}'
	}

case "$1" in
	click)
		current_mode=$(load_state)
		if [ "$current_mode" = "night" ]; then
			set_temp "identity"
			save_state "day"
			update_output "day" "$(get_temp)"
		else
			set_temp 2500
			save_state "night"
			update_output "night" 2500
		fi
		;;
	scroll-up)
		temp=$(get_temp)
		new_temp=$((temp + STEP))
		(( new_temp > MAX_TEMP )) && new_temp=$MAX_TEMP
		set_temp "$new_temp"
		save_state "custom"
		update_output "custom" "$new_temp"
		;;
	scroll-down)
		temp=$(get_temp)
		new_temp=$((temp - STEP))
		(( new_temp < MIN_TEMP )) && new_temp=$MIN_TEMP
		set_temp "$new_temp"
		save_state "custom"
		update_output "custom" "$new_temp"
		;;
	*)
		temp=$(get_temp)
		mode=$(load_state)
		update_output "$mode" "$temp"
		;;
esac
