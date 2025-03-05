#!/bin/bash

query=$1

current_time=$(date +%s)
seconds_ago=$((query - current_time))

# Determine if the timestamp is in the past or future
if [[ $seconds_ago -lt 0 ]]; then
direction="ago"
# Convert to positive for calculations
seconds_ago=$((seconds_ago * -1))
else
direction="in the future"
fi

days=$((seconds_ago / 86400))
remaining_seconds=$((seconds_ago % 86400))
hours=$((remaining_seconds / 3600))
remaining_seconds=$((remaining_seconds % 3600))
minutes=$((remaining_seconds / 60))
seconds=$((remaining_seconds % 60))

output=""

if [[ $days -gt 0 ]]; then
output+="${days} days "
fi
if [[ $hours -gt 0 ]]; then
output+="${hours} hours "
fi
if [[ $minutes -gt 0 ]]; then
output+="${minutes} minutes "
fi
if [[ $seconds -gt 0 ]]; then
output+="${seconds} seconds"
fi

cat << EOB
{"items": [
	{
		"title": "$(date -r $query +"%Y-%m-%d %H:%M:%S %Z")",
		"arg": "$(date -r $query +"%Y-%m-%d %H:%M:%S %Z")"
	},
	{
		"title": "$(TZ=UTC date -ur $query +"%Y-%m-%dT%H:%M:%S") UTC",
		"arg": "$(TZ=UTC date -ur $query +"%Y-%m-%dT%H:%M:%S") UTC"
	},
	{
		"title": "$output $direction",
		"arg": "$output $direction"
	}
]}
EOB
