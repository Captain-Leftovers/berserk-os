#!/usr/bin/env bats

# =============================================================================
# Unit tests for modules/src/revert-to-2.3.sh
# Tests the revert wrapper script structure and behavior.
# =============================================================================

REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
REVERT_SCRIPT="$REPO_ROOT/modules/src/revert-to-2.3.sh"

# ---------------------------------------------------------------------------
# Script existence and structure
# ---------------------------------------------------------------------------

@test "revert script exists" {
	[ -f "$REVERT_SCRIPT" ]
}

@test "revert script starts with bash shebang" {
	head -1 "$REVERT_SCRIPT" | grep -q '#!/usr/bin/env bash'
}

@test "revert script defines color variables" {
	grep -q "RED=" "$REVERT_SCRIPT"
	grep -q "GREEN=" "$REVERT_SCRIPT"
	grep -q "YELLOW=" "$REVERT_SCRIPT"
	grep -q "BLUE=" "$REVERT_SCRIPT"
	grep -q "CYAN=" "$REVERT_SCRIPT"
	grep -q "NC=" "$REVERT_SCRIPT"
}

# ---------------------------------------------------------------------------
# Dependency on upgrade script
# ---------------------------------------------------------------------------

@test "revert script references upgrade-2.3-to-2.4.sh" {
	grep -q 'upgrade-2.3-to-2.4.sh' "$REVERT_SCRIPT"
}

@test "revert script checks if upgrade script exists" {
	grep -q '! -f "$UPGRADE_SCRIPT"' "$REVERT_SCRIPT"
}

@test "revert script makes upgrade script executable if needed" {
	grep -q 'chmod +x' "$REVERT_SCRIPT"
}

@test "revert script passes --revert flag to upgrade script" {
	grep -q '\-\-revert' "$REVERT_SCRIPT"
}

# ---------------------------------------------------------------------------
# Branch handling
# ---------------------------------------------------------------------------

@test "revert script defaults BRANCH to stable-2.4" {
	grep -q 'BRANCH=.*stable-2.4' "$REVERT_SCRIPT"
}

@test "revert script exports BRANCH variable" {
	grep -q 'export BRANCH' "$REVERT_SCRIPT"
}

# ---------------------------------------------------------------------------
# User messaging
# ---------------------------------------------------------------------------

@test "revert script displays warning about reverting" {
	grep -q 'revert' "$REVERT_SCRIPT"
}

@test "revert script mentions backup usage" {
	grep -q 'backup' "$REVERT_SCRIPT"
}

@test "revert script tells user to be in zaneyos directory" {
	grep -q 'zaneyos' "$REVERT_SCRIPT"
}
