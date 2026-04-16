#!/usr/bin/env bats

# =============================================================================
# Unit tests for host configurations
# Verifies that each host has required files and that variables.nix contains
# all mandatory fields with valid values.
# =============================================================================

REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"

# ---------------------------------------------------------------------------
# Required variables that every host must define
# ---------------------------------------------------------------------------
REQUIRED_STRING_VARS=(
	gitUsername
	gitEmail
	displayManager
	browser
	terminal
	keyboardLayout
	consoleKeyMap
	hostId
)

REQUIRED_BOOL_VARS=(
	enableNFS
	printEnable
	thunarEnable
	clock24h
)

REQUIRED_PATH_VARS=(
	stylixImage
	waybarChoice
	animChoice
)

# ---------------------------------------------------------------------------
# Host directory completeness
# ---------------------------------------------------------------------------

@test "hosts/default directory exists" {
	[ -d "$REPO_ROOT/hosts/default" ]
}

@test "hosts/default has variables.nix" {
	[ -f "$REPO_ROOT/hosts/default/variables.nix" ]
}

@test "hosts/default has hardware.nix" {
	[ -f "$REPO_ROOT/hosts/default/hardware.nix" ]
}

@test "hosts/default has default.nix" {
	[ -f "$REPO_ROOT/hosts/default/default.nix" ]
}

@test "hosts/default has host-packages.nix" {
	[ -f "$REPO_ROOT/hosts/default/host-packages.nix" ]
}

@test "hosts/berserk directory exists" {
	[ -d "$REPO_ROOT/hosts/berserk" ]
}

@test "hosts/berserk has variables.nix" {
	[ -f "$REPO_ROOT/hosts/berserk/variables.nix" ]
}

@test "hosts/berserk has hardware.nix" {
	[ -f "$REPO_ROOT/hosts/berserk/hardware.nix" ]
}

@test "hosts/berserk has default.nix" {
	[ -f "$REPO_ROOT/hosts/berserk/default.nix" ]
}

@test "hosts/berserk has host-packages.nix" {
	[ -f "$REPO_ROOT/hosts/berserk/host-packages.nix" ]
}

# ---------------------------------------------------------------------------
# Every host has required files
# ---------------------------------------------------------------------------

@test "all hosts have variables.nix" {
	local missing=""
	for dir in "$REPO_ROOT"/hosts/*/; do
		local host
		host=$(basename "$dir")
		if [ ! -f "$dir/variables.nix" ]; then
			missing="$missing $host"
		fi
	done
	[ -z "$missing" ] || {
		echo "Missing variables.nix:$missing"
		false
	}
}

@test "all hosts have default.nix" {
	local missing=""
	for dir in "$REPO_ROOT"/hosts/*/; do
		local host
		host=$(basename "$dir")
		if [ ! -f "$dir/default.nix" ]; then
			missing="$missing $host"
		fi
	done
	[ -z "$missing" ] || {
		echo "Missing default.nix:$missing"
		false
	}
}

@test "all hosts have hardware.nix" {
	local missing=""
	for dir in "$REPO_ROOT"/hosts/*/; do
		local host
		host=$(basename "$dir")
		if [ ! -f "$dir/hardware.nix" ]; then
			missing="$missing $host"
		fi
	done
	[ -z "$missing" ] || {
		echo "Missing hardware.nix:$missing"
		false
	}
}

# ---------------------------------------------------------------------------
# Variables.nix field presence in all hosts
# ---------------------------------------------------------------------------

@test "all hosts define required string variables" {
	local errors=""
	for dir in "$REPO_ROOT"/hosts/*/; do
		local host
		host=$(basename "$dir")
		local vars_file="$dir/variables.nix"
		[ -f "$vars_file" ] || continue
		for var in "${REQUIRED_STRING_VARS[@]}"; do
			if ! grep -q "$var" "$vars_file"; then
				errors="$errors $host:$var"
			fi
		done
	done
	[ -z "$errors" ] || {
		echo "Missing string variables:$errors"
		false
	}
}

@test "all hosts define required boolean variables" {
	local errors=""
	for dir in "$REPO_ROOT"/hosts/*/; do
		local host
		host=$(basename "$dir")
		local vars_file="$dir/variables.nix"
		[ -f "$vars_file" ] || continue
		for var in "${REQUIRED_BOOL_VARS[@]}"; do
			if ! grep -q "$var" "$vars_file"; then
				errors="$errors $host:$var"
			fi
		done
	done
	[ -z "$errors" ] || {
		echo "Missing boolean variables:$errors"
		false
	}
}

@test "all hosts define required path variables" {
	local errors=""
	for dir in "$REPO_ROOT"/hosts/*/; do
		local host
		host=$(basename "$dir")
		local vars_file="$dir/variables.nix"
		[ -f "$vars_file" ] || continue
		for var in "${REQUIRED_PATH_VARS[@]}"; do
			if ! grep -q "$var" "$vars_file"; then
				errors="$errors $host:$var"
			fi
		done
	done
	[ -z "$errors" ] || {
		echo "Missing path variables:$errors"
		false
	}
}

# ---------------------------------------------------------------------------
# Variables.nix value validation
# ---------------------------------------------------------------------------

@test "displayManager is either 'sddm' or 'tui' in all hosts" {
	local errors=""
	for dir in "$REPO_ROOT"/hosts/*/; do
		local host
		host=$(basename "$dir")
		local vars_file="$dir/variables.nix"
		[ -f "$vars_file" ] || continue
		local dm
		dm=$(grep 'displayManager' "$vars_file" | grep -v '#' | sed 's/.*= *"\([^"]*\)".*/\1/' | head -1)
		if [ -n "$dm" ] && [ "$dm" != "sddm" ] && [ "$dm" != "tui" ]; then
			errors="$errors $host:$dm"
		fi
	done
	[ -z "$errors" ] || {
		echo "Invalid displayManager values:$errors"
		false
	}
}

@test "hostId is a valid hex string in all hosts" {
	local errors=""
	for dir in "$REPO_ROOT"/hosts/*/; do
		local host
		host=$(basename "$dir")
		local vars_file="$dir/variables.nix"
		[ -f "$vars_file" ] || continue
		local hid
		hid=$(grep 'hostId' "$vars_file" | grep -v '#' | sed 's/.*= *"\([^"]*\)".*/\1/' | head -1)
		if [ -n "$hid" ]; then
			if ! echo "$hid" | grep -qE '^[0-9a-fA-F]{8}$'; then
				errors="$errors $host:$hid"
			fi
		fi
	done
	[ -z "$errors" ] || {
		echo "Invalid hostId values:$errors"
		false
	}
}

@test "keyboardLayout is set and non-empty in all hosts" {
	local errors=""
	for dir in "$REPO_ROOT"/hosts/*/; do
		local host
		host=$(basename "$dir")
		local vars_file="$dir/variables.nix"
		[ -f "$vars_file" ] || continue
		local kl
		kl=$(grep 'keyboardLayout' "$vars_file" | grep -v '#' | sed 's/.*= *"\([^"]*\)".*/\1/' | head -1)
		if [ -z "$kl" ]; then
			errors="$errors $host"
		fi
	done
	[ -z "$errors" ] || {
		echo "Empty keyboardLayout:$errors"
		false
	}
}

# ---------------------------------------------------------------------------
# Host default.nix imports required files
# ---------------------------------------------------------------------------

@test "all host default.nix files import hardware.nix" {
	local errors=""
	for dir in "$REPO_ROOT"/hosts/*/; do
		local host
		host=$(basename "$dir")
		local dn="$dir/default.nix"
		[ -f "$dn" ] || continue
		if ! grep -q 'hardware.nix' "$dn"; then
			errors="$errors $host"
		fi
	done
	[ -z "$errors" ] || {
		echo "Missing hardware.nix import:$errors"
		false
	}
}

@test "all host default.nix files import host-packages.nix" {
	local errors=""
	for dir in "$REPO_ROOT"/hosts/*/; do
		local host
		host=$(basename "$dir")
		local dn="$dir/default.nix"
		[ -f "$dn" ] || continue
		if ! grep -q 'host-packages.nix' "$dn"; then
			errors="$errors $host"
		fi
	done
	[ -z "$errors" ] || {
		echo "Missing host-packages.nix import:$errors"
		false
	}
}

# ---------------------------------------------------------------------------
# Profile completeness
# ---------------------------------------------------------------------------

@test "profile: amd exists" {
	[ -d "$REPO_ROOT/profiles/amd" ]
	[ -f "$REPO_ROOT/profiles/amd/default.nix" ]
}

@test "profile: intel exists" {
	[ -d "$REPO_ROOT/profiles/intel" ]
	[ -f "$REPO_ROOT/profiles/intel/default.nix" ]
}

@test "profile: nvidia exists" {
	[ -d "$REPO_ROOT/profiles/nvidia" ]
	[ -f "$REPO_ROOT/profiles/nvidia/default.nix" ]
}

@test "profile: nvidia-laptop exists" {
	[ -d "$REPO_ROOT/profiles/nvidia-laptop" ]
	[ -f "$REPO_ROOT/profiles/nvidia-laptop/default.nix" ]
}

@test "profile: vm exists" {
	[ -d "$REPO_ROOT/profiles/vm" ]
	[ -f "$REPO_ROOT/profiles/vm/default.nix" ]
}

# ---------------------------------------------------------------------------
# Flake.nix validation
# ---------------------------------------------------------------------------

@test "flake.nix exists at repo root" {
	[ -f "$REPO_ROOT/flake.nix" ]
}

@test "flake.nix defines nixosConfigurations" {
	grep -q 'nixosConfigurations' "$REPO_ROOT/flake.nix"
}

@test "flake.nix has configuration for all profiles" {
	for profile in amd nvidia nvidia-laptop intel vm; do
		grep -q "$profile" "$REPO_ROOT/flake.nix" || {
			echo "Missing profile: $profile"
			false
		}
	done
}

@test "flake.nix references nixpkgs input" {
	grep -q 'nixpkgs' "$REPO_ROOT/flake.nix"
}

@test "flake.nix references home-manager input" {
	grep -q 'home-manager' "$REPO_ROOT/flake.nix"
}

@test "flake.nix references stylix input" {
	grep -q 'stylix' "$REPO_ROOT/flake.nix"
}

@test "flake.lock exists and is not empty" {
	[ -s "$REPO_ROOT/flake.lock" ]
}
