#!/bin/bash
# autoresearch correctness checks
# Must exit 0 if the project is still valid (compiles + tests pass)
# Must exit non-zero if something broke

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo ">> Building project..."
cd "$SCRIPT_DIR"
if ! swift build 2>&1; then
    echo "FAIL: Build failed"
    exit 1
fi

echo ""
echo ">> Running tests..."
if ! swift test 2>&1; then
    echo "FAIL: Tests failed"
    exit 1
fi

echo ""
echo ">> All checks passed"
exit 0
