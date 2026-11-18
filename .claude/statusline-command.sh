#!/bin/bash
# Claude Code statusLine script
# Shows: model display name | context remaining % | 5-hour session usage [time left]: used %
# Reads the statusLine JSON payload from stdin; degrades gracefully if a
# field is missing (no network calls, jq is the only dependency).

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // empty')
remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
five_hour=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_hour_resets=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')

parts=()

if [ -n "$model" ]; then
  parts+=("$model")
fi

if [ -n "$remaining" ]; then
  parts+=("Ctx left: $(printf '%.0f' "$remaining")%")
fi

if [ -n "$five_hour" ]; then
  five_hour_str="5h"
  if [ -n "$five_hour_resets" ]; then
    now=$(date +%s)
    remaining_sec=$(( five_hour_resets - now ))
    if [ "$remaining_sec" -lt 0 ]; then remaining_sec=0; fi
    remaining_min=$(( remaining_sec / 60 ))
    five_hour_str="5h[${remaining_min}m]"
  fi
  parts+=("${five_hour_str}: $(printf '%.0f' "$five_hour")%")
fi

if [ "${#parts[@]}" -eq 0 ]; then
  echo "Claude Code"
else
  out="${parts[0]}"
  for p in "${parts[@]:1}"; do
    out="$out | $p"
  done
  echo "$out"
fi
