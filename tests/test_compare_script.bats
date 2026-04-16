#!/usr/bin/env bats

# =============================================================================
# Unit tests for modules/src/compare-zaneyos-config.sh
# Tests argument parsing, function definitions, and comparison logic.
# =============================================================================

REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
COMPARE_SCRIPT="$REPO_ROOT/modules/src/compare-zaneyos-config.sh"

# ---------------------------------------------------------------------------
# Setup / teardown
# ---------------------------------------------------------------------------

setup() {
	TEST_TMPDIR="$(mktemp -d)"
}

teardown() {
	rm -rf "$TEST_TMPDIR"
}

# ---------------------------------------------------------------------------
# Script existence and structure
# ---------------------------------------------------------------------------

@test "compare script exists" {
	[ -f "$COMPARE_SCRIPT" ]
}

@test "compare script starts with bash shebang" {
	head -1 "$COMPARE_SCRIPT" | grep -q '#!/usr/bin/env bash'
}

@test "compare script defines color variables" {
	grep -q "RED=" "$COMPARE_SCRIPT"
	grep -q "GREEN=" "$COMPARE_SCRIPT"
	grep -q "YELLOW=" "$COMPARE_SCRIPT"
	grep -q "BLUE=" "$COMPARE_SCRIPT"
	grep -q "CYAN=" "$COMPARE_SCRIPT"
	grep -q "NC=" "$COMPARE_SCRIPT"
}

# ---------------------------------------------------------------------------
# Function definitions
# ---------------------------------------------------------------------------

@test "compare script defines print_header function" {
	grep -q '^print_header()' "$COMPARE_SCRIPT"
}

@test "compare script defines print_error function" {
	grep -q '^print_error()' "$COMPARE_SCRIPT"
}

@test "compare script defines print_warning function" {
	grep -q '^print_warning()' "$COMPARE_SCRIPT"
}

@test "compare script defines print_success function" {
	grep -q '^print_success()' "$COMPARE_SCRIPT"
}

@test "compare script defines print_info function" {
	grep -q '^print_info()' "$COMPARE_SCRIPT"
}

@test "compare script defines show_usage function" {
	grep -q '^show_usage()' "$COMPARE_SCRIPT"
}

@test "compare script defines cleanup function" {
	grep -q '^cleanup()' "$COMPARE_SCRIPT"
}

@test "compare script defines perform_comparison function" {
	grep -q '^perform_comparison()' "$COMPARE_SCRIPT"
}

# ---------------------------------------------------------------------------
# Default configuration values
# ---------------------------------------------------------------------------

@test "compare script sets default repo URL" {
	grep -q 'DEFAULT_REPO=' "$COMPARE_SCRIPT"
	grep -q 'gitlab.com/zaney/zaneyos' "$COMPARE_SCRIPT"
}

@test "compare script sets default branch to main" {
	grep -q 'DEFAULT_BRANCH="main"' "$COMPARE_SCRIPT"
}

# ---------------------------------------------------------------------------
# Argument parsing
# ---------------------------------------------------------------------------

@test "compare script supports -r/--repo flag" {
	grep -q '\-r|--repo' "$COMPARE_SCRIPT"
}

@test "compare script supports -b/--branch flag" {
	grep -q '\-b|--branch' "$COMPARE_SCRIPT"
}

@test "compare script supports -o/--output flag" {
	grep -q '\-o|--output' "$COMPARE_SCRIPT"
}

@test "compare script supports -h/--help flag" {
	grep -q '\-h|--help' "$COMPARE_SCRIPT"
}

@test "compare script handles unknown options" {
	grep -q 'Unknown option' "$COMPARE_SCRIPT"
}

# ---------------------------------------------------------------------------
# Cleanup trap
# ---------------------------------------------------------------------------

@test "compare script sets EXIT trap for cleanup" {
	grep -q 'trap cleanup EXIT' "$COMPARE_SCRIPT"
}

@test "cleanup function removes temp directory" {
	grep -q 'rm -rf' "$COMPARE_SCRIPT"
}

# ---------------------------------------------------------------------------
# Comparison sections
# ---------------------------------------------------------------------------

@test "compare script compares flake.nix" {
	grep -q 'FLAKE.NIX COMPARISON' "$COMPARE_SCRIPT"
}

@test "compare script compares global packages" {
	grep -q 'GLOBAL PACKAGES COMPARISON' "$COMPARE_SCRIPT"
}

@test "compare script compares host configurations" {
	grep -q 'HOST CONFIGURATIONS COMPARISON' "$COMPARE_SCRIPT"
}

@test "compare script compares shell configurations" {
	grep -q 'SHELL CONFIGURATIONS COMPARISON' "$COMPARE_SCRIPT"
}

@test "compare script generates repository statistics" {
	grep -q 'REPOSITORY STATISTICS' "$COMPARE_SCRIPT"
}

@test "compare script provides summary and recommendations" {
	grep -q 'SUMMARY & RECOMMENDATIONS' "$COMPARE_SCRIPT"
}

# ---------------------------------------------------------------------------
# Comparison includes expected shell files
# ---------------------------------------------------------------------------

@test "compare script checks zsh default.nix" {
	grep -q 'modules/home/zsh/default.nix' "$COMPARE_SCRIPT"
}

@test "compare script checks zshrc-personal.nix" {
	grep -q 'zshrc-personal.nix' "$COMPARE_SCRIPT"
}

@test "compare script checks bash.nix" {
	grep -q 'modules/home/bash.nix' "$COMPARE_SCRIPT"
}

@test "compare script checks bashrc-personal.nix" {
	grep -q 'bashrc-personal.nix' "$COMPARE_SCRIPT"
}

# ---------------------------------------------------------------------------
# Git analysis features
# ---------------------------------------------------------------------------

@test "compare script checks git status" {
	grep -q 'GIT REPOSITORY STATUS' "$COMPARE_SCRIPT"
}

@test "compare script detects uncommitted changes" {
	grep -q 'diff-index' "$COMPARE_SCRIPT"
}

@test "compare script shows remote origin" {
	grep -q 'remote get-url origin' "$COMPARE_SCRIPT"
}

# ---------------------------------------------------------------------------
# Report output
# ---------------------------------------------------------------------------

@test "compare script saves report to file via tee" {
	grep -q 'tee.*REPORT_FILE' "$COMPARE_SCRIPT"
}

@test "compare script generates timestamped report filename" {
	grep -q 'zaneyos-config-comparison' "$COMPARE_SCRIPT"
}
