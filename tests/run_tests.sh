#!/usr/bin/env bash

# =============================================================================
# Test runner for berserk-os unit tests
# Runs all .bats test files in the tests/ directory.
# Exit code is non-zero if any test fails.
# =============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "========================================"
echo "  berserk-os test suite"
echo "========================================"
echo ""

FAILED=0

for test_file in "$SCRIPT_DIR"/*.bats; do
	echo "--- Running: $(basename "$test_file") ---"
	if ! bats "$test_file"; then
		FAILED=1
	fi
	echo ""
done

echo "========================================"
if [ "$FAILED" -eq 0 ]; then
	echo "  All test suites passed!"
else
	echo "  Some tests failed. See output above."
fi
echo "========================================"

exit "$FAILED"
