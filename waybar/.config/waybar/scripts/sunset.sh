#!/usr/bin/bash

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
	[[ -f "$STATE_FILE" ]] && cat "$STATE_FILE" || echo "identity"
}

