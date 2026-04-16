#!/usr/bin/env bats

# =============================================================================
# Unit tests for NixOS module structure and configuration validation
# Verifies that all service modules exist, have correct structure, and that
# host/profile configurations are complete and consistent.
# =============================================================================

REPO_ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")/.." && pwd)"

# ---------------------------------------------------------------------------
# Core service modules existence
# ---------------------------------------------------------------------------

@test "core module: services.nix exists" {
	[ -f "$REPO_ROOT/modules/core/services.nix" ]
}

@test "core module: network.nix exists" {
	[ -f "$REPO_ROOT/modules/core/network.nix" ]
}

@test "core module: security.nix exists" {
	[ -f "$REPO_ROOT/modules/core/security.nix" ]
}

@test "core module: printing.nix exists" {
	[ -f "$REPO_ROOT/modules/core/printing.nix" ]
}

@test "core module: boot.nix exists" {
	[ -f "$REPO_ROOT/modules/core/boot.nix" ]
}

@test "core module: syncthing.nix exists" {
	[ -f "$REPO_ROOT/modules/core/syncthing.nix" ]
}

@test "core module: virtualisation.nix exists" {
	[ -f "$REPO_ROOT/modules/core/virtualisation.nix" ]
}

@test "core module: steam.nix exists" {
	[ -f "$REPO_ROOT/modules/core/steam.nix" ]
}

@test "core module: nfs.nix exists" {
	[ -f "$REPO_ROOT/modules/core/nfs.nix" ]
}

@test "core module: sddm.nix exists" {
	[ -f "$REPO_ROOT/modules/core/sddm.nix" ]
}

@test "core module: greetd.nix exists" {
	[ -f "$REPO_ROOT/modules/core/greetd.nix" ]
}

@test "core module: xserver.nix exists" {
	[ -f "$REPO_ROOT/modules/core/xserver.nix" ]
}

@test "core module: system.nix exists" {
	[ -f "$REPO_ROOT/modules/core/system.nix" ]
}

@test "core module: user.nix exists" {
	[ -f "$REPO_ROOT/modules/core/user.nix" ]
}

@test "core module: packages.nix exists" {
	[ -f "$REPO_ROOT/modules/core/packages.nix" ]
}

@test "core module: fonts.nix exists" {
	[ -f "$REPO_ROOT/modules/core/fonts.nix" ]
}

@test "core module: hardware.nix exists" {
	[ -f "$REPO_ROOT/modules/core/hardware.nix" ]
}

@test "core module: stylix.nix exists" {
	[ -f "$REPO_ROOT/modules/core/stylix.nix" ]
}

@test "core module: nh.nix exists" {
	[ -f "$REPO_ROOT/modules/core/nh.nix" ]
}

@test "core module: expressvpn-system.nix exists" {
	[ -f "$REPO_ROOT/modules/core/expressvpn-system.nix" ]
}

@test "core module: nixpkgs.nix exists" {
	[ -f "$REPO_ROOT/modules/core/nixpkgs.nix" ]
}

@test "core module: onlyoffice.nix exists" {
	[ -f "$REPO_ROOT/modules/core/onlyoffice.nix" ]
}

# ---------------------------------------------------------------------------
# Core default.nix imports all expected modules
# ---------------------------------------------------------------------------

@test "core default.nix imports boot.nix" {
	grep -q './boot.nix' "$REPO_ROOT/modules/core/default.nix"
}

@test "core default.nix imports services.nix" {
	grep -q './services.nix' "$REPO_ROOT/modules/core/default.nix"
}

@test "core default.nix imports network.nix" {
	grep -q './network.nix' "$REPO_ROOT/modules/core/default.nix"
}

@test "core default.nix imports security.nix" {
	grep -q './security.nix' "$REPO_ROOT/modules/core/default.nix"
}

@test "core default.nix imports printing.nix" {
	grep -q './printing.nix' "$REPO_ROOT/modules/core/default.nix"
}

@test "core default.nix imports syncthing.nix" {
	grep -q './syncthing.nix' "$REPO_ROOT/modules/core/default.nix"
}

@test "core default.nix imports virtualisation.nix" {
	grep -q './virtualisation.nix' "$REPO_ROOT/modules/core/default.nix"
}

@test "core default.nix imports steam.nix" {
	grep -q './steam.nix' "$REPO_ROOT/modules/core/default.nix"
}

@test "core default.nix imports nfs.nix" {
	grep -q './nfs.nix' "$REPO_ROOT/modules/core/default.nix"
}

@test "core default.nix imports system.nix" {
	grep -q './system.nix' "$REPO_ROOT/modules/core/default.nix"
}

@test "core default.nix imports user.nix" {
	grep -q './user.nix' "$REPO_ROOT/modules/core/default.nix"
}

@test "core default.nix imports packages.nix" {
	grep -q './packages.nix' "$REPO_ROOT/modules/core/default.nix"
}

@test "core default.nix imports fonts.nix" {
	grep -q './fonts.nix' "$REPO_ROOT/modules/core/default.nix"
}

@test "core default.nix imports hardware.nix" {
	grep -q './hardware.nix' "$REPO_ROOT/modules/core/default.nix"
}

@test "core default.nix imports xserver.nix" {
	grep -q './xserver.nix' "$REPO_ROOT/modules/core/default.nix"
}

@test "core default.nix imports stylix module" {
	grep -q 'stylix' "$REPO_ROOT/modules/core/default.nix"
}

@test "core default.nix imports nh.nix" {
	grep -q './nh.nix' "$REPO_ROOT/modules/core/default.nix"
}

@test "core default.nix imports onlyoffice.nix" {
	grep -q './onlyoffice.nix' "$REPO_ROOT/modules/core/default.nix"
}

@test "core default.nix imports nixpkgs.nix" {
	grep -q './nixpkgs.nix' "$REPO_ROOT/modules/core/default.nix"
}

# ---------------------------------------------------------------------------
# Services.nix content validation
# ---------------------------------------------------------------------------

@test "services.nix enables pipewire" {
	grep -q 'pipewire' "$REPO_ROOT/modules/core/services.nix"
}

@test "services.nix configures openssh" {
	grep -q 'openssh' "$REPO_ROOT/modules/core/services.nix"
}

@test "services.nix disables SSH root login" {
	grep -q 'PermitRootLogin.*no' "$REPO_ROOT/modules/core/services.nix"
}

@test "services.nix enables fstrim for SSD" {
	grep -q 'fstrim.enable = true' "$REPO_ROOT/modules/core/services.nix"
}

@test "services.nix enables gvfs" {
	grep -q 'gvfs.enable = true' "$REPO_ROOT/modules/core/services.nix"
}

@test "services.nix enables gnome-keyring" {
	grep -q 'gnome-keyring.enable = true' "$REPO_ROOT/modules/core/services.nix"
}

@test "services.nix enables tumbler" {
	grep -q 'tumbler.enable = true' "$REPO_ROOT/modules/core/services.nix"
}

@test "services.nix enables upower" {
	grep -q 'upower.enable = true' "$REPO_ROOT/modules/core/services.nix"
}

@test "services.nix conditionally disables smartd for VM profile" {
	grep -q 'profile == "vm"' "$REPO_ROOT/modules/core/services.nix"
}

@test "services.nix sets pipewire low-latency clock rate to 48000" {
	grep -q '48000' "$REPO_ROOT/modules/core/services.nix"
}

@test "services.nix configures SSH on port 22" {
	grep -q 'ports = \[22\]' "$REPO_ROOT/modules/core/services.nix"
}

# ---------------------------------------------------------------------------
# Network.nix content validation
# ---------------------------------------------------------------------------

@test "network.nix enables NetworkManager" {
	grep -q 'networkmanager.enable = true' "$REPO_ROOT/modules/core/network.nix"
}

@test "network.nix enables firewall" {
	grep -q 'firewall' "$REPO_ROOT/modules/core/network.nix"
	grep -q 'enable = true' "$REPO_ROOT/modules/core/network.nix"
}

@test "network.nix opens TCP port 22 (SSH)" {
	grep -q '22' "$REPO_ROOT/modules/core/network.nix"
}

@test "network.nix opens TCP port 80 (HTTP)" {
	grep -q '80' "$REPO_ROOT/modules/core/network.nix"
}

@test "network.nix opens TCP port 443 (HTTPS)" {
	grep -q '443' "$REPO_ROOT/modules/core/network.nix"
}

@test "network.nix has hostname assertion" {
	grep -q 'assertions' "$REPO_ROOT/modules/core/network.nix"
}

@test "network.nix sets hostId from variables" {
	grep -q 'hostId' "$REPO_ROOT/modules/core/network.nix"
}

# ---------------------------------------------------------------------------
# Security.nix content validation
# ---------------------------------------------------------------------------

@test "security.nix enables rtkit" {
	grep -q 'rtkit.enable = true' "$REPO_ROOT/modules/core/security.nix"
}

@test "security.nix enables polkit" {
	grep -q 'polkit' "$REPO_ROOT/modules/core/security.nix"
}

@test "security.nix configures swaylock PAM service" {
	grep -q 'swaylock' "$REPO_ROOT/modules/core/security.nix"
}

@test "security.nix polkit allows users group to reboot" {
	grep -q 'org.freedesktop.login1.reboot' "$REPO_ROOT/modules/core/security.nix"
}

@test "security.nix polkit allows users group to power-off" {
	grep -q 'org.freedesktop.login1.power-off' "$REPO_ROOT/modules/core/security.nix"
}

# ---------------------------------------------------------------------------
# Boot.nix content validation
# ---------------------------------------------------------------------------

@test "boot.nix uses zen kernel" {
	grep -q 'linuxPackages_zen' "$REPO_ROOT/modules/core/boot.nix"
}

@test "boot.nix enables systemd-boot" {
	grep -q 'systemd-boot.enable = true' "$REPO_ROOT/modules/core/boot.nix"
}

@test "boot.nix enables plymouth" {
	grep -q 'plymouth.enable = true' "$REPO_ROOT/modules/core/boot.nix"
}

@test "boot.nix configures appimage support" {
	grep -q 'appimage' "$REPO_ROOT/modules/core/boot.nix"
}

@test "boot.nix loads v4l2loopback kernel module" {
	grep -q 'v4l2loopback' "$REPO_ROOT/modules/core/boot.nix"
}

# ---------------------------------------------------------------------------
# Syncthing.nix content validation
# ---------------------------------------------------------------------------

@test "syncthing.nix enables syncthing service" {
	grep -q 'enable = true' "$REPO_ROOT/modules/core/syncthing.nix"
}

@test "syncthing.nix binds to localhost only" {
	grep -q '127.0.0.1:8384' "$REPO_ROOT/modules/core/syncthing.nix"
}

@test "syncthing.nix sets user from username arg" {
	grep -q 'username' "$REPO_ROOT/modules/core/syncthing.nix"
}

# ---------------------------------------------------------------------------
# Virtualisation.nix content validation
# ---------------------------------------------------------------------------

@test "virtualisation.nix enables docker" {
	grep -q 'docker' "$REPO_ROOT/modules/core/virtualisation.nix"
	grep -q 'enable = true' "$REPO_ROOT/modules/core/virtualisation.nix"
}

@test "virtualisation.nix disables podman (mutual exclusion with docker)" {
	grep -q 'podman.enable = false' "$REPO_ROOT/modules/core/virtualisation.nix"
}

@test "virtualisation.nix enables libvirtd" {
	grep -q 'libvirtd' "$REPO_ROOT/modules/core/virtualisation.nix"
}

# ---------------------------------------------------------------------------
# Printing.nix content validation
# ---------------------------------------------------------------------------

@test "printing.nix references printEnable variable" {
	grep -q 'printEnable' "$REPO_ROOT/modules/core/printing.nix"
}

@test "printing.nix configures avahi for network printing" {
	grep -q 'avahi' "$REPO_ROOT/modules/core/printing.nix"
}

@test "printing.nix configures ipp-usb" {
	grep -q 'ipp-usb' "$REPO_ROOT/modules/core/printing.nix"
}

# ---------------------------------------------------------------------------
# NFS.nix content validation
# ---------------------------------------------------------------------------

@test "nfs.nix references enableNFS variable" {
	grep -q 'enableNFS' "$REPO_ROOT/modules/core/nfs.nix"
}

@test "nfs.nix configures rpcbind service" {
	grep -q 'rpcbind' "$REPO_ROOT/modules/core/nfs.nix"
}

# ---------------------------------------------------------------------------
# ExpressVPN system service validation
# ---------------------------------------------------------------------------

@test "expressvpn-system.nix defines systemd service" {
	grep -q 'systemd.services.expressvpnd' "$REPO_ROOT/modules/core/expressvpn-system.nix"
}

@test "expressvpn-system.nix sets wantedBy multi-user target" {
	grep -q 'multi-user.target' "$REPO_ROOT/modules/core/expressvpn-system.nix"
}

@test "expressvpn-system.nix starts after network" {
	grep -q 'network.target' "$REPO_ROOT/modules/core/expressvpn-system.nix"
}

@test "expressvpn-system.nix sets restart policy to always" {
	grep -q 'Restart = "always"' "$REPO_ROOT/modules/core/expressvpn-system.nix"
}

# ---------------------------------------------------------------------------
# Display manager modules
# ---------------------------------------------------------------------------

@test "sddm.nix enables SDDM with wayland" {
	grep -q 'wayland.enable = true' "$REPO_ROOT/modules/core/sddm.nix"
}

@test "sddm.nix uses astronaut theme" {
	grep -q 'sddm-astronaut' "$REPO_ROOT/modules/core/sddm.nix"
}

@test "greetd.nix enables greetd" {
	grep -q 'enable = true' "$REPO_ROOT/modules/core/greetd.nix"
}

@test "greetd.nix uses tuigreet to start Hyprland" {
	grep -q 'tuigreet' "$REPO_ROOT/modules/core/greetd.nix"
	grep -q 'Hyprland' "$REPO_ROOT/modules/core/greetd.nix"
}

# ---------------------------------------------------------------------------
# System.nix content validation
# ---------------------------------------------------------------------------

@test "system.nix enables nix flakes" {
	grep -q 'flakes' "$REPO_ROOT/modules/core/system.nix"
}

@test "system.nix enables nix-command" {
	grep -q 'nix-command' "$REPO_ROOT/modules/core/system.nix"
}

@test "system.nix sets ZANEYOS_VERSION env var" {
	grep -q 'ZANEYOS_VERSION' "$REPO_ROOT/modules/core/system.nix"
}

@test "system.nix sets stateVersion to 23.11" {
	grep -q 'stateVersion = "23.11"' "$REPO_ROOT/modules/core/system.nix"
}

# ---------------------------------------------------------------------------
# XServer.nix content validation
# ---------------------------------------------------------------------------

@test "xserver.nix references keyboardLayout variable" {
	grep -q 'keyboardLayout' "$REPO_ROOT/modules/core/xserver.nix"
}

# ---------------------------------------------------------------------------
# Steam.nix content validation
# ---------------------------------------------------------------------------

@test "steam.nix enables steam" {
	grep -q 'steam' "$REPO_ROOT/modules/core/steam.nix"
}

@test "steam.nix enables gamescope" {
	grep -q 'gamescope' "$REPO_ROOT/modules/core/steam.nix"
}

@test "steam.nix opens firewall for remote play" {
	grep -q 'remotePlay.openFirewall = true' "$REPO_ROOT/modules/core/steam.nix"
}

# ---------------------------------------------------------------------------
# Driver modules
# ---------------------------------------------------------------------------

@test "driver module: amd-drivers.nix exists" {
	[ -f "$REPO_ROOT/modules/drivers/amd-drivers.nix" ]
}

@test "driver module: intel-drivers.nix exists" {
	[ -f "$REPO_ROOT/modules/drivers/intel-drivers.nix" ]
}

@test "driver module: nvidia-drivers.nix exists" {
	[ -f "$REPO_ROOT/modules/drivers/nvidia-drivers.nix" ]
}

@test "driver module: nvidia-prime-drivers.nix exists" {
	[ -f "$REPO_ROOT/modules/drivers/nvidia-prime-drivers.nix" ]
}

@test "driver module: vm-guest-services.nix exists" {
	[ -f "$REPO_ROOT/modules/drivers/vm-guest-services.nix" ]
}

@test "drivers default.nix imports all driver modules" {
	grep -q 'amd-drivers.nix' "$REPO_ROOT/modules/drivers/default.nix"
	grep -q 'intel-drivers.nix' "$REPO_ROOT/modules/drivers/default.nix"
	grep -q 'nvidia-drivers.nix' "$REPO_ROOT/modules/drivers/default.nix"
	grep -q 'nvidia-prime-drivers.nix' "$REPO_ROOT/modules/drivers/default.nix"
	grep -q 'vm-guest-services.nix' "$REPO_ROOT/modules/drivers/default.nix"
}

@test "vm-guest-services.nix defines enable option" {
	grep -q 'mkEnableOption' "$REPO_ROOT/modules/drivers/vm-guest-services.nix"
}

@test "vm-guest-services.nix enables qemu guest agent when active" {
	grep -q 'qemuGuest.enable = true' "$REPO_ROOT/modules/drivers/vm-guest-services.nix"
}

@test "vm-guest-services.nix enables spice agent when active" {
	grep -q 'spice-vdagentd.enable = true' "$REPO_ROOT/modules/drivers/vm-guest-services.nix"
}

# ---------------------------------------------------------------------------
# Nix syntax: balanced braces in all .nix files
# ---------------------------------------------------------------------------

@test "all .nix files have balanced curly braces" {
	local failed=""
	while IFS= read -r f; do
		local opens closes
		opens=$(tr -cd '{' <"$f" | wc -c)
		closes=$(tr -cd '}' <"$f" | wc -c)
		if [ "$opens" -ne "$closes" ]; then
			failed="$failed $f (open=$opens close=$closes)"
		fi
	done < <(find "$REPO_ROOT" -name '*.nix' -not -path '*/.git/*')
	[ -z "$failed" ] || {
		echo "Unbalanced braces:$failed"
		false
	}
}

@test "all .nix files have balanced square brackets (outside string literals)" {
	# Only check files that do NOT contain multi-line string literals ('') or
	# quoted bracket characters (e.g. "<C-[>" key bindings in config data).
	# Files with such content may legitimately have unbalanced brackets.
	local failed=""
	while IFS= read -r f; do
		# Skip files that use Nix multi-line strings ('' ... '') or contain
		# bracket characters inside quoted strings (common in keybinding configs).
		if grep -qE "''|\"[^\"]*\[" "$f"; then
			continue
		fi
		local opens closes
		opens=$(tr -cd '[' <"$f" | wc -c)
		closes=$(tr -cd ']' <"$f" | wc -c)
		if [ "$opens" -ne "$closes" ]; then
			failed="$failed $f (open=$opens close=$closes)"
		fi
	done < <(find "$REPO_ROOT" -name '*.nix' -not -path '*/.git/*')
	[ -z "$failed" ] || {
		echo "Unbalanced brackets:$failed"
		false
	}
}

@test "no .nix files contain syntax error markers (>>>, <<<, ===)" {
	local failed=""
	while IFS= read -r f; do
		if grep -Eq '^(>>>|<<<|===)' "$f"; then
			failed="$failed $f"
		fi
	done < <(find "$REPO_ROOT" -name '*.nix' -not -path '*/.git/*')
	[ -z "$failed" ] || {
		echo "Merge conflict markers found:$failed"
		false
	}
}
