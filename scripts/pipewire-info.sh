#!/bin/bash

# Find the first occurrence of the clock rate and quantum from pw-dump
#RATE=$(pw-dump | grep -m1 '"clock.rate"' | awk -F'"' '{print $4}')
#QUANTUM=$(pw-dump | grep -m1 '"clock.quantum"' | awk -F'"' '{print $4}')

eval "$(pw-dump -N | jq -r '
  .[]
  | select(.props["metadata.name"] == "settings")
  | .metadata
  | map({ (.key): .value })
  | add
  | "QUANTUM=\(.["clock.force-quantum"])\nRATE=\(.["clock.force-rate"])"
'
)"

# Check if both values were successfully retrieved
if [[ -n "$RATE" && -n "$QUANTUM" ]]; then
  # Calculate latency in milliseconds
  # Using 'bc' for floating-point arithmetic
  LATENCY=$(echo "scale=2; ($QUANTUM * 1000 / $RATE)" | bc)

  printf "Quantum \${alignr}%s\n" "$QUANTUM"
  printf "Rate \${alignr}%g kHz\n" "$(echo "scale=1; $RATE/1000" | bc)"
  printf "Latency \${alignr}%g ms\n" "$LATENCY"
else
  echo "PipeWire not running"
fi

