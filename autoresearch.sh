#!/bin/bash
# autoresearch benchmark script
# Must output a single number — the metric to optimize (lower is better)

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
OUTPUT=$(bash "$SCRIPT_DIR/analyze_architecture.sh" "$SCRIPT_DIR" 2>/dev/null)

# Extract the metric value
METRIC=$(echo "$OUTPUT" | grep "^AUTORESEARCH_METRIC=" | cut -d'=' -f2)

echo "$METRIC"
