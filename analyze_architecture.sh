#!/bin/bash
# Architecture Metrics Analyzer for Swift SPM projects
# Outputs a composite score (lower is better)

set -uo pipefail

PROJECT_DIR="${1:-.}"
SOURCES_DIR="$PROJECT_DIR/Sources"

echo "=== Architecture Metrics Analysis ==="
echo ""

# Get modules
modules=""
for dir in "$SOURCES_DIR"/*/; do
    mod=$(basename "$dir")
    modules="$modules $mod"
done
echo "Modules:$modules"
echo ""

# ============================================================
# METRIC 1: Efferent Coupling (Ce) per module + total
# ============================================================
echo "--- Efferent Coupling (Ce) ---"
total_ce=0
ce_values=""

for mod in $modules; do
    mod_dir="$SOURCES_DIR/$mod"
    ce=0
    for other in $modules; do
        if [ "$mod" != "$other" ]; then
            count=$(grep -rl "^import ${other}$" "$mod_dir" 2>/dev/null | wc -l | tr -d ' ' || true)
            if [ "$count" -gt 0 ]; then
                ce=$((ce + 1))
            fi
        fi
    done
    ce_values="$ce_values ${mod}:${ce}"
    total_ce=$((total_ce + ce))
    echo "  $mod: Ce=$ce"
done
echo "  Total Ce: $total_ce"
echo ""

# ============================================================
# METRIC 2: Afferent Coupling (Ca) per module
# ============================================================
echo "--- Afferent Coupling (Ca) ---"
ca_values=""

for mod in $modules; do
    ca=0
    for other in $modules; do
        if [ "$mod" != "$other" ]; then
            other_dir="$SOURCES_DIR/$other"
            count=$(grep -rl "^import ${mod}$" "$other_dir" 2>/dev/null | wc -l | tr -d ' ')
            if [ "$count" -gt 0 ]; then
                ca=$((ca + 1))
            fi
        fi
    done
    ca_values="$ca_values ${mod}:${ca}"
    echo "  $mod: Ca=$ca"
done
echo ""

# ============================================================
# METRIC 3: Instability per module I = Ce / (Ca + Ce)
# ============================================================
echo "--- Instability ---"
total_instability=0
mod_count=0

for mod in $modules; do
    # Extract Ce for this module
    ce=0
    for pair in $ce_values; do
        key="${pair%%:*}"
        val="${pair##*:}"
        if [ "$key" = "$mod" ]; then ce=$val; break; fi
    done
    # Extract Ca for this module
    ca=0
    for pair in $ca_values; do
        key="${pair%%:*}"
        val="${pair##*:}"
        if [ "$key" = "$mod" ]; then ca=$val; break; fi
    done

    sum=$((ca + ce))
    if [ "$sum" -gt 0 ]; then
        instability=$(( (ce * 100) / sum ))
    else
        instability=0
    fi
    echo "  $mod: I=${instability}%"
    total_instability=$((total_instability + instability))
    mod_count=$((mod_count + 1))
done

avg_instability=$((total_instability / mod_count))
echo "  Average Instability: ${avg_instability}%"
echo ""

# ============================================================
# METRIC 4: Total cross-module import statements
# ============================================================
total_imports=$(grep -r "^import " "$SOURCES_DIR" --include="*.swift" 2>/dev/null | grep -v "Foundation" | grep -v "SwiftUI" | grep -v "UIKit" | wc -l | tr -d ' ')
echo "--- Cross-module imports: $total_imports ---"
echo ""

# ============================================================
# METRIC 5: Max lines per file (God class detection)
# ============================================================
echo "--- File sizes ---"
max_lines=0
total_lines=0
file_count=0
max_file=""

for file in $(find "$SOURCES_DIR" -name "*.swift" -type f); do
    lines=$(wc -l < "$file" | tr -d ' ')
    total_lines=$((total_lines + lines))
    file_count=$((file_count + 1))
    if [ "$lines" -gt "$max_lines" ]; then
        max_lines=$lines
        max_file=$(basename "$file")
    fi
done

avg_lines=$((total_lines / file_count))
echo "  Files: $file_count | Total lines: $total_lines | Avg: $avg_lines | Max: $max_lines ($max_file)"
echo ""

# ============================================================
# METRIC 6: Singletons
# ============================================================
singleton_count=$(grep -r "static let shared" "$SOURCES_DIR" --include="*.swift" 2>/dev/null | wc -l | tr -d ' ')
echo "--- Singletons: $singleton_count ---"

# ============================================================
# METRIC 7: Abstraction (protocols vs concrete classes)
# ============================================================
protocol_count=$(grep -r "^protocol " "$SOURCES_DIR" --include="*.swift" 2>/dev/null | wc -l | tr -d ' ')
class_count=$(grep -rE "^public (final )?class |^class " "$SOURCES_DIR" --include="*.swift" 2>/dev/null | wc -l | tr -d ' ')
echo "--- Protocols: $protocol_count | Classes: $class_count ---"

if [ "$((protocol_count + class_count))" -gt 0 ]; then
    abstractness=$(( (protocol_count * 100) / (protocol_count + class_count) ))
else
    abstractness=0
fi
echo "--- Abstractness: ${abstractness}% ---"
echo ""

# ============================================================
# COMPOSITE SCORE (lower = better architecture)
# ============================================================
coupling_score=$((total_ce * 3))
instability_score=$((avg_instability * 2))
import_score=$total_imports
size_score=$((max_lines / 10))
singleton_score=$((singleton_count * 20))
abstraction_penalty=$(( (100 - abstractness) * 2 ))

composite=$((coupling_score + instability_score + import_score + size_score + singleton_score + abstraction_penalty))

echo "=== COMPOSITE SCORE BREAKDOWN ==="
echo "  Coupling (Ce×3):        $coupling_score"
echo "  Instability (avg×2):    $instability_score"
echo "  Imports:                $import_score"
echo "  Max file size (/10):    $size_score"
echo "  Singletons (×20):      $singleton_score"
echo "  Abstraction penalty:    $abstraction_penalty"
echo ""
echo "  ════════════════════════"
echo "  TOTAL SCORE: $composite"
echo "  ════════════════════════"
echo "  (lower is better)"

# For autoresearch: output just the metric
echo ""
echo "AUTORESEARCH_METRIC=$composite"
