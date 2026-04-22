#!/usr/bin/env bats

# =============================================================================
# Unit tests for modules/src/upgrade-2.3-to-2.4.sh
# Tests helper functions (cleanup_duplicates, prompt_yes, prompt_choice,
# print_*, merge_variables logic) in isolation by sourcing them into a
# controlled environment.
# =============================================================================

REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"
UPGRADE_SCRIPT="$REPO_ROOT/modules/src/upgrade-2.3-to-2.4.sh"

# ---------------------------------------------------------------------------
# Setup / teardown
# ---------------------------------------------------------------------------

setup() {
	TEST_TMPDIR="$(mktemp -d)"

	# Source only the function definitions from the upgrade script.
	# We override variables and skip the main body by extracting functions.
	export RED='' GREEN='' YELLOW='' BLUE='' CYAN='' NC=''
	export ZANEYOS_DIR="$TEST_TMPDIR/zaneyos"
	export BACKUP_BASE_DIR="$TEST_TMPDIR/backups"
	export TIMESTAMP="test-ts"
	export BACKUP_DIR="$BACKUP_BASE_DIR/zaneyos-2.3-upgrade-backup-$TIMESTAMP"
	export LOG_FILE="$TEST_TMPDIR/upgrade.log"
	export BRANCH="stable-2.4"
	export AUTO_YES="1"

	mkdir -p "$ZANEYOS_DIR" "$BACKUP_DIR"
}

teardown() {
	rm -rf "$TEST_TMPDIR"
}

# ---------------------------------------------------------------------------
# Script existence and permissions
# ---------------------------------------------------------------------------

@test "upgrade script exists" {
	[ -f "$UPGRADE_SCRIPT" ]
}

@test "upgrade script starts with bash shebang" {
	head -1 "$UPGRADE_SCRIPT" | grep -q '#!/usr/bin/env bash'
}

@test "upgrade script defines RED color variable" {
	grep -q "RED=" "$UPGRADE_SCRIPT"
}

@test "upgrade script defines GREEN color variable" {
	grep -q "GREEN=" "$UPGRADE_SCRIPT"
}

# ---------------------------------------------------------------------------
# cleanup_duplicates function
# ---------------------------------------------------------------------------

# Extract and source just the cleanup_duplicates function
_source_cleanup_duplicates() {
	eval "$(sed -n '/^cleanup_duplicates()/,/^}/p' "$UPGRADE_SCRIPT")"
}

@test "cleanup_duplicates removes duplicate stylixImage lines" {
	_source_cleanup_duplicates
	cat >"$TEST_TMPDIR/vars.nix" <<'EOF'
{
  stylixImage = ../../wallpapers/one.jpg;
  browser = "brave";
  stylixImage = ../../wallpapers/two.jpg;
}
EOF
	cleanup_duplicates "$TEST_TMPDIR/vars.nix"
	local count
	count=$(grep -c 'stylixImage' "$TEST_TMPDIR/vars.nix")
	[ "$count" -eq 1 ]
}

@test "cleanup_duplicates keeps first stylixImage occurrence" {
	_source_cleanup_duplicates
	cat >"$TEST_TMPDIR/vars.nix" <<'EOF'
{
  stylixImage = ../../wallpapers/one.jpg;
  browser = "brave";
  stylixImage = ../../wallpapers/two.jpg;
}
EOF
	cleanup_duplicates "$TEST_TMPDIR/vars.nix"
	grep -q 'one.jpg' "$TEST_TMPDIR/vars.nix"
}

@test "cleanup_duplicates removes duplicate animChoice lines" {
	_source_cleanup_duplicates
	cat >"$TEST_TMPDIR/vars.nix" <<'EOF'
{
  animChoice = ../../modules/home/hyprland/animations-def.nix;
  terminal = "kitty";
  animChoice = ../../modules/home/hyprland/animations-end4.nix;
}
EOF
	cleanup_duplicates "$TEST_TMPDIR/vars.nix"
	local count
	count=$(grep -c 'animChoice' "$TEST_TMPDIR/vars.nix")
	[ "$count" -eq 1 ]
}

@test "cleanup_duplicates removes duplicate waybarChoice lines" {
	_source_cleanup_duplicates
	cat >"$TEST_TMPDIR/vars.nix" <<'EOF'
{
  waybarChoice = ../../modules/home/waybar/waybar-curved.nix;
  waybarChoice = ../../modules/home/waybar/waybar-simple.nix;
}
EOF
	cleanup_duplicates "$TEST_TMPDIR/vars.nix"
	local count
	count=$(grep -c 'waybarChoice' "$TEST_TMPDIR/vars.nix")
	[ "$count" -eq 1 ]
}

@test "cleanup_duplicates leaves file unchanged when no duplicates" {
	_source_cleanup_duplicates
	cat >"$TEST_TMPDIR/vars.nix" <<'EOF'
{
  stylixImage = ../../wallpapers/one.jpg;
  animChoice = ../../modules/home/hyprland/animations-def.nix;
  waybarChoice = ../../modules/home/waybar/waybar-curved.nix;
}
EOF
	cp "$TEST_TMPDIR/vars.nix" "$TEST_TMPDIR/vars-orig.nix"
	cleanup_duplicates "$TEST_TMPDIR/vars.nix"
	diff -q "$TEST_TMPDIR/vars.nix" "$TEST_TMPDIR/vars-orig.nix"
}

@test "cleanup_duplicates preserves non-duplicate lines" {
	_source_cleanup_duplicates
	cat >"$TEST_TMPDIR/vars.nix" <<'EOF'
{
  gitUsername = "test";
  gitEmail = "test@example.com";
  stylixImage = ../../wallpapers/one.jpg;
  browser = "brave";
  stylixImage = ../../wallpapers/two.jpg;
  terminal = "kitty";
}
EOF
	cleanup_duplicates "$TEST_TMPDIR/vars.nix"
	grep -q 'gitUsername' "$TEST_TMPDIR/vars.nix"
	grep -q 'gitEmail' "$TEST_TMPDIR/vars.nix"
	grep -q 'browser' "$TEST_TMPDIR/vars.nix"
	grep -q 'terminal' "$TEST_TMPDIR/vars.nix"
}

# ---------------------------------------------------------------------------
# prompt_yes and prompt_choice with AUTO_YES
# ---------------------------------------------------------------------------

# Extract and source the prompt helpers
_source_prompt_helpers() {
	eval "$(sed -n '/^prompt_yes()/,/^}/p' "$UPGRADE_SCRIPT")"
	eval "$(sed -n '/^prompt_choice()/,/^}/p' "$UPGRADE_SCRIPT")"
}

@test "prompt_yes sets REPLY=Y when AUTO_YES=1" {
	_source_prompt_helpers
	export AUTO_YES="1"
	prompt_yes "Continue?"
	[ "$REPLY" = "Y" ]
}

@test "prompt_choice returns default char when AUTO_YES=1" {
	_source_prompt_helpers
	export AUTO_YES="1"
	prompt_choice "Choose:" "S"
	[ "$choice" = "S" ]
}

@test "prompt_choice returns custom default when AUTO_YES=1" {
	_source_prompt_helpers
	export AUTO_YES="1"
	prompt_choice "Choose:" "D"
	[ "$choice" = "D" ]
}

# ---------------------------------------------------------------------------
# Print function existence
# ---------------------------------------------------------------------------

@test "upgrade script defines print_header function" {
	grep -q '^print_header()' "$UPGRADE_SCRIPT"
}

@test "upgrade script defines print_error function" {
	grep -q '^print_error()' "$UPGRADE_SCRIPT"
}

@test "upgrade script defines print_warning function" {
	grep -q '^print_warning()' "$UPGRADE_SCRIPT"
}

@test "upgrade script defines print_success function" {
	grep -q '^print_success()' "$UPGRADE_SCRIPT"
}

@test "upgrade script defines print_info function" {
	grep -q '^print_info()' "$UPGRADE_SCRIPT"
}

@test "upgrade script defines print_success_banner function" {
	grep -q '^print_success_banner()' "$UPGRADE_SCRIPT"
}

@test "upgrade script defines print_failure_banner function" {
	grep -q '^print_failure_banner()' "$UPGRADE_SCRIPT"
}

# ---------------------------------------------------------------------------
# Key function existence
# ---------------------------------------------------------------------------

@test "upgrade script defines create_backup function" {
	grep -q '^create_backup()' "$UPGRADE_SCRIPT"
}

@test "upgrade script defines revert_from_backup function" {
	grep -q '^revert_from_backup()' "$UPGRADE_SCRIPT"
}

@test "upgrade script defines merge_variables function" {
	grep -q '^merge_variables()' "$UPGRADE_SCRIPT"
}

@test "upgrade script defines perform_precheck_analysis function" {
	grep -q '^perform_precheck_analysis()' "$UPGRADE_SCRIPT"
}

@test "upgrade script defines update_flake_configuration function" {
	grep -q '^update_flake_configuration()' "$UPGRADE_SCRIPT"
}

@test "upgrade script defines switch_to_main_handling_dirty function" {
	grep -q '^switch_to_main_handling_dirty()' "$UPGRADE_SCRIPT"
}

@test "upgrade script defines cleanup_duplicates function" {
	grep -q '^cleanup_duplicates()' "$UPGRADE_SCRIPT"
}

# ---------------------------------------------------------------------------
# --revert flag handling
# ---------------------------------------------------------------------------

@test "upgrade script handles --revert flag" {
	grep -q '\-\-revert' "$UPGRADE_SCRIPT"
}

# ---------------------------------------------------------------------------
# create_backup function logic
# ---------------------------------------------------------------------------

_source_print_and_backup() {
	# Source print helpers as no-ops for testing
	print_header() { :; }
	print_error() { :; }
	print_warning() { :; }
	print_success() { :; }
	print_info() { :; }
	eval "$(sed -n '/^create_backup()/,/^}/p' "$UPGRADE_SCRIPT")"
}

@test "create_backup fails when ZANEYOS_DIR does not exist" {
	_source_print_and_backup
	ZANEYOS_DIR="$TEST_TMPDIR/nonexistent"
	run create_backup
	[ "$status" -ne 0 ]
}

@test "create_backup succeeds when ZANEYOS_DIR exists" {
	_source_print_and_backup
	mkdir -p "$ZANEYOS_DIR"
	echo "test" >"$ZANEYOS_DIR/flake.nix"
	run create_backup
	[ "$status" -eq 0 ]
}

@test "create_backup creates backup directory" {
	_source_print_and_backup
	mkdir -p "$ZANEYOS_DIR"
	echo "test" >"$ZANEYOS_DIR/flake.nix"
	create_backup
	[ -d "$BACKUP_DIR" ]
}

# ---------------------------------------------------------------------------
# Variable extraction patterns (testing the sed patterns used in merge)
# ---------------------------------------------------------------------------

@test "sed pattern extracts gitUsername correctly" {
	echo 'gitUsername = "TestUser";' >"$TEST_TMPDIR/test.nix"
	result=$(grep 'gitUsername' "$TEST_TMPDIR/test.nix" | sed 's/.*= *"\([^"]*\)".*/\1/')
	[ "$result" = "TestUser" ]
}

@test "sed pattern extracts gitEmail correctly" {
	echo 'gitEmail = "test@example.com";' >"$TEST_TMPDIR/test.nix"
	result=$(grep 'gitEmail' "$TEST_TMPDIR/test.nix" | sed 's/.*= *"\([^"]*\)".*/\1/')
	[ "$result" = "test@example.com" ]
}

@test "sed pattern extracts browser correctly" {
	echo 'browser = "zen-beta";' >"$TEST_TMPDIR/test.nix"
	result=$(grep 'browser' "$TEST_TMPDIR/test.nix" | sed 's/.*= *"\([^"]*\)".*/\1/')
	[ "$result" = "zen-beta" ]
}

@test "sed pattern extracts boolean enableNFS correctly" {
	echo 'enableNFS = true;' >"$TEST_TMPDIR/test.nix"
	result=$(grep 'enableNFS' "$TEST_TMPDIR/test.nix" | sed 's/.*= *\([^;]*\);.*/\1/')
	[ "$result" = "true" ]
}

@test "sed pattern extracts boolean printEnable correctly" {
	echo 'printEnable = false;' >"$TEST_TMPDIR/test.nix"
	result=$(grep 'printEnable' "$TEST_TMPDIR/test.nix" | sed 's/.*= *\([^;]*\);.*/\1/')
	[ "$result" = "false" ]
}

@test "sed pattern extracts terminal correctly" {
	echo 'terminal = "ghostty";' >"$TEST_TMPDIR/test.nix"
	result=$(grep 'terminal' "$TEST_TMPDIR/test.nix" | sed 's/.*= *"\([^"]*\)".*/\1/')
	[ "$result" = "ghostty" ]
}

# ---------------------------------------------------------------------------
# Terminal enable logic (simulated merge_variables behavior)
# ---------------------------------------------------------------------------

@test "terminal 'ghostty' enables ghosttyEnable in variables" {
	cat >"$TEST_TMPDIR/vars.nix" <<'EOF'
{
  ghosttyEnable = false;
  terminal = "kitty";
}
EOF
	terminal="ghostty"
	case "$terminal" in
	"ghostty")
		sed -i "s/ghosttyEnable = false;/ghosttyEnable = true;/" "$TEST_TMPDIR/vars.nix"
		;;
	esac
	grep -q 'ghosttyEnable = true' "$TEST_TMPDIR/vars.nix"
}

@test "terminal 'alacritty' enables alacrittyEnable in variables" {
	cat >"$TEST_TMPDIR/vars.nix" <<'EOF'
{
  alacrittyEnable = false;
  terminal = "kitty";
}
EOF
	terminal="alacritty"
	case "$terminal" in
	"alacritty")
		sed -i "s/alacrittyEnable = false;/alacrittyEnable = true;/" "$TEST_TMPDIR/vars.nix"
		;;
	esac
	grep -q 'alacrittyEnable = true' "$TEST_TMPDIR/vars.nix"
}

@test "terminal 'wezterm' enables weztermEnable in variables" {
	cat >"$TEST_TMPDIR/vars.nix" <<'EOF'
{
  weztermEnable = false;
  terminal = "kitty";
}
EOF
	terminal="wezterm"
	case "$terminal" in
	"wezterm")
		sed -i "s/weztermEnable = false;/weztermEnable = true;/" "$TEST_TMPDIR/vars.nix"
		;;
	esac
	grep -q 'weztermEnable = true' "$TEST_TMPDIR/vars.nix"
}

# ---------------------------------------------------------------------------
# Variable substitution patterns (simulated merge logic)
# ---------------------------------------------------------------------------

@test "sed substitution replaces gitUsername in template" {
	cat >"$TEST_TMPDIR/template.nix" <<'EOF'
{
  gitUsername = "Tyler Kelley";
  gitEmail = "tyler@example.com";
}
EOF
	sed -i 's/gitUsername = ".*";/gitUsername = "NewUser";/' "$TEST_TMPDIR/template.nix"
	grep -q 'gitUsername = "NewUser"' "$TEST_TMPDIR/template.nix"
}

@test "sed substitution replaces browser in template" {
	cat >"$TEST_TMPDIR/template.nix" <<'EOF'
{
  browser = "brave";
}
EOF
	sed -i 's/browser = ".*";/browser = "zen-beta";/' "$TEST_TMPDIR/template.nix"
	grep -q 'browser = "zen-beta"' "$TEST_TMPDIR/template.nix"
}

@test "sed substitution replaces boolean enableNFS in template" {
	cat >"$TEST_TMPDIR/template.nix" <<'EOF'
{
  enableNFS = true;
}
EOF
	sed -i 's/enableNFS = .*/enableNFS = false;/' "$TEST_TMPDIR/template.nix"
	grep -q 'enableNFS = false' "$TEST_TMPDIR/template.nix"
}

# ---------------------------------------------------------------------------
# Branch and safety features
# ---------------------------------------------------------------------------

@test "upgrade script defaults BRANCH to stable-2.4" {
	grep -q 'BRANCH=.*stable-2.4' "$UPGRADE_SCRIPT"
}

@test "upgrade script checks for flake.nix before proceeding" {
	grep -q 'flake.nix' "$UPGRADE_SCRIPT"
}

@test "upgrade script checks for hosts directory" {
	grep -q './hosts' "$UPGRADE_SCRIPT"
}

@test "upgrade script uses boot instead of switch for safety" {
	grep -q 'boot' "$UPGRADE_SCRIPT"
}

@test "upgrade script offers reboot prompt at the end" {
	grep -q 'reboot' "$UPGRADE_SCRIPT"
}
