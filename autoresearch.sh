#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

# Quick syntax check
cd "$SCRIPT_DIR"
swift build 2>&1 | tail -5 || { echo "METRIC arch_score=0"; exit 1; }

OUTPUT=$(bash "$SCRIPT_DIR/analyze_architecture.sh" "$SCRIPT_DIR" 2>/dev/null)

# Extract individual metrics
METRIC=$(echo "$OUTPUT" | grep "^AUTORESEARCH_METRIC=" | cut -d'=' -f2)
COUPLING=$(echo "$OUTPUT" | grep "Coupling (Ce×3):" | awk '{print $NF}')
INSTABILITY=$(echo "$OUTPUT" | grep "Instability (avg×2):" | awk '{print $NF}')
IMPORTS=$(echo "$OUTPUT" | grep "Imports:" | awk '{print $NF}')
SINGLETONS=$(echo "$OUTPUT" | grep "Singletons (×20):" | awk '{print $NF}')
ABSTRACTION=$(echo "$OUTPUT" | grep "Abstraction penalty:" | awk '{print $NF}')
SIZE=$(echo "$OUTPUT" | grep "Max file size" | awk '{print $NF}')

echo "METRIC arch_score=$METRIC"
echo "METRIC coupling=$COUPLING"
echo "METRIC instability=$INSTABILITY"
echo "METRIC imports=$IMPORTS"
echo "METRIC singletons=$SINGLETONS"
echo "METRIC abstraction_penalty=$ABSTRACTION"
echo "METRIC size_score=$SIZE"
