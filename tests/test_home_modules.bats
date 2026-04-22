#!/usr/bin/env bats

# =============================================================================
# Unit tests for home-manager module structure
# Verifies that all expected home modules exist, the default.nix composes
# them correctly, and script modules are present.
# =============================================================================

REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"

# ---------------------------------------------------------------------------
# Home module directory structure
# ---------------------------------------------------------------------------

@test "home module directory exists" {
	[ -d "$REPO_ROOT/modules/home" ]
}

@test "home default.nix exists" {
	[ -f "$REPO_ROOT/modules/home/default.nix" ]
}

# ---------------------------------------------------------------------------
# Core home modules existence
# ---------------------------------------------------------------------------

@test "home module: bash.nix exists" {
	[ -f "$REPO_ROOT/modules/home/bash.nix" ]
}

@test "home module: git.nix exists" {
	[ -f "$REPO_ROOT/modules/home/git.nix" ]
}

@test "home module: gtk.nix exists" {
	[ -f "$REPO_ROOT/modules/home/gtk.nix" ]
}

@test "home module: programs.nix exists" {
	[ -f "$REPO_ROOT/modules/home/programs.nix" ]
}

@test "home module: stylix.nix exists" {
	[ -f "$REPO_ROOT/modules/home/stylix.nix" ]
}

@test "home module: swaync.nix exists" {
	[ -f "$REPO_ROOT/modules/home/swaync.nix" ]
}

@test "home module: btop.nix exists" {
	[ -f "$REPO_ROOT/modules/home/btop.nix" ]
}

@test "home module: fzf.nix exists" {
	[ -f "$REPO_ROOT/modules/home/fzf.nix" ]
}

@test "home module: zoxide.nix exists" {
	[ -f "$REPO_ROOT/modules/home/zoxide.nix" ]
}

@test "home module: bat.nix exists" {
	[ -f "$REPO_ROOT/modules/home/bat.nix" ]
}

@test "home module: xdg.nix exists" {
	[ -f "$REPO_ROOT/modules/home/xdg.nix" ]
}

@test "home module: qt.nix exists" {
	[ -f "$REPO_ROOT/modules/home/qt.nix" ]
}

# ---------------------------------------------------------------------------
# Terminal emulator modules
# ---------------------------------------------------------------------------

@test "home module: alacritty.nix exists" {
	[ -f "$REPO_ROOT/modules/home/alacritty.nix" ]
}

@test "home module: ghostty.nix exists" {
	[ -f "$REPO_ROOT/modules/home/ghostty.nix" ]
}

@test "home module: wezterm.nix exists" {
	[ -f "$REPO_ROOT/modules/home/wezterm.nix" ]
}

# ---------------------------------------------------------------------------
# Application modules
# ---------------------------------------------------------------------------

@test "home module: obs-studio.nix exists" {
	[ -f "$REPO_ROOT/modules/home/obs-studio.nix" ]
}

@test "home module: lazygit.nix exists" {
	[ -f "$REPO_ROOT/modules/home/lazygit.nix" ]
}

@test "home module: bottom.nix exists" {
	[ -f "$REPO_ROOT/modules/home/bottom.nix" ]
}

@test "home module: htop.nix exists" {
	[ -f "$REPO_ROOT/modules/home/htop.nix" ]
}

@test "home module: zen.nix exists" {
	[ -f "$REPO_ROOT/modules/home/zen.nix" ]
}

@test "home module: expressvpn.nix exists" {
	[ -f "$REPO_ROOT/modules/home/expressvpn.nix" ]
}

# ---------------------------------------------------------------------------
# Subdirectory modules
# ---------------------------------------------------------------------------

@test "home module: zsh directory exists with default.nix" {
	[ -d "$REPO_ROOT/modules/home/zsh" ]
	[ -f "$REPO_ROOT/modules/home/zsh/default.nix" ]
}

@test "home module: waybar directory exists" {
	[ -d "$REPO_ROOT/modules/home/waybar" ]
}

@test "home module: rofi directory exists with default.nix" {
	[ -d "$REPO_ROOT/modules/home/rofi" ]
	[ -f "$REPO_ROOT/modules/home/rofi/default.nix" ]
}

@test "home module: yazi directory exists with default.nix" {
	[ -d "$REPO_ROOT/modules/home/yazi" ]
	[ -f "$REPO_ROOT/modules/home/yazi/default.nix" ]
}

@test "home module: wlogout directory exists with default.nix" {
	[ -d "$REPO_ROOT/modules/home/wlogout" ]
	[ -f "$REPO_ROOT/modules/home/wlogout/default.nix" ]
}

@test "home module: editors directory exists" {
	[ -d "$REPO_ROOT/modules/home/editors" ]
}

# ---------------------------------------------------------------------------
# Scripts module
# ---------------------------------------------------------------------------

@test "home scripts directory exists" {
	[ -d "$REPO_ROOT/modules/home/scripts" ]
}

@test "home scripts default.nix exists" {
	[ -f "$REPO_ROOT/modules/home/scripts/default.nix" ]
}

@test "home script: zcli.nix exists" {
	[ -f "$REPO_ROOT/modules/home/scripts/zcli.nix" ]
}

@test "home script: screenshootin.nix exists" {
	[ -f "$REPO_ROOT/modules/home/scripts/screenshootin.nix" ]
}

@test "home script: rofi-launcher.nix exists" {
	[ -f "$REPO_ROOT/modules/home/scripts/rofi-launcher.nix" ]
}

@test "home script: wallsetter.nix exists" {
	[ -f "$REPO_ROOT/modules/home/scripts/wallsetter.nix" ]
}

@test "home script: web-search.nix exists" {
	[ -f "$REPO_ROOT/modules/home/scripts/web-search.nix" ]
}

@test "home script: emopicker9000.nix exists" {
	[ -f "$REPO_ROOT/modules/home/scripts/emopicker9000.nix" ]
}

@test "home script: keybinds.nix exists" {
	[ -f "$REPO_ROOT/modules/home/scripts/keybinds.nix" ]
}

# ---------------------------------------------------------------------------
# Waybar variant modules
# ---------------------------------------------------------------------------

@test "waybar: waybar-curved.nix exists" {
	[ -f "$REPO_ROOT/modules/home/waybar/waybar-curved.nix" ]
}

@test "waybar: waybar-simple.nix exists" {
	[ -f "$REPO_ROOT/modules/home/waybar/waybar-simple.nix" ]
}

@test "waybar: waybar-ddubs.nix exists" {
	[ -f "$REPO_ROOT/modules/home/waybar/waybar-ddubs.nix" ]
}

@test "waybar: waybar-jerry.nix exists" {
	[ -f "$REPO_ROOT/modules/home/waybar/waybar-jerry.nix" ]
}

@test "waybar: waybar-dwm.nix exists" {
	[ -f "$REPO_ROOT/modules/home/waybar/waybar-dwm.nix" ]
}

# ---------------------------------------------------------------------------
# Wallpapers directory
# ---------------------------------------------------------------------------

@test "wallpapers directory exists" {
	[ -d "$REPO_ROOT/wallpapers" ]
}

@test "wallpapers directory contains image files" {
	local count
	count=$(find "$REPO_ROOT/wallpapers" -type f \( -name '*.jpg' -o -name '*.png' -o -name '*.jpeg' \) | wc -l)
	[ "$count" -gt 0 ]
}

@test "default stylixImage wallpaper exists" {
	[ -f "$REPO_ROOT/wallpapers/mountainscapedark.jpg" ]
}
