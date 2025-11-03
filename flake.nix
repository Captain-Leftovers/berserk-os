{
  # A short human-readable label that appears in `nix flake info`.
  description = "BerserkOS";

  ############################
  # 1) FLAKE INPUTS
  ############################
  # Inputs are other flakes (or git repos) this flake depends on.
  # Each input gets pinned in flake.lock for reproducibility.
  inputs = {
    # Home Manager stable branch matching NixOS 25.05.
    # The `follows = "nixpkgs"` line keeps HM's nixpkgs aligned with ours.
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Your primary NixOS package set (stable 25.05 channel).
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    # Unstable channel for selectively pulling newer packages when needed.
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # NVF (NotAShelf's Neovim Flake) – if you use it for Neovim configs.
    nvf.url = "github:notashelf/nvf";

    # Stylix theming pinned to 25.05 to match your base.
    stylix.url = "github:danth/stylix/release-25.05";

    # Nix Flatpak module – lets you declaratively install/manage Flatpaks.
    # The ?ref=latest makes sure we pull its advertised stable ref.
    nix-flatpak.url = "github:gmodena/nix-flatpak?ref=latest";

    # Zen browser as a flake with inputs aligned to our nixpkgs & HM.
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
    zen-browser.inputs.home-manager.follows = "home-manager";

    # Hypr system info helper (optional – commented out until you need it).
    # hyprsysteminfo.url = "github:hyprwm/hyprsysteminfo";

    # QuickShell for custom panels/bars. Keeping nixpkgs in sync via follows.
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  ############################
  # 2) FLAKE OUTPUTS
  ############################
  # `outputs` is a function. Nix passes all inputs in; we pattern-match out
  # what we care about. The `@inputs` tail lets us still access everything
  # by name (useful to forward inputs wholesale into modules).
  outputs =
    {
      nixpkgs,
      home-manager,
      nix-flatpak,
      quickshell,
      zen-browser,
      # nvf, stylix, hyprsysteminfo could also be listed here if referenced below.
      ...
    }@inputs:

    # `let` holds local constants reused across configs to avoid repetition.
    let
      # Target CPU/OS platform for your hosts (common ThinkPad default).
      system = "x86_64-linux";

      # Logical host name you want inside your modules (can be used for
      # conditional logic in profiles or in HM).
      host = "berserk";

      # High-level profile name you want available to modules (e.g., which GPU stack).
      profile = "amd";

      # Primary login user; used to thread into Home Manager config.
      username = "beeondweb";

      # Helper to construct a NixOS configuration per-GPU/profile while
      # deduplicating shared logic. You pass "amd" | "nvidia" | "intel" | "vm",
      # it wires the right profile module + shared modules.
      mkNixosConfig = gpuProfile:
        nixpkgs.lib.nixosSystem {
          # The architecture to build for.
          inherit system;

          # Values made available to every module via `specialArgs`.
          # This is how your modules can reference `inputs`, `username`, etc.
          specialArgs = {
            inherit inputs;
            inherit username;
            inherit host;
            inherit profile;   # stays the outer `profile` unless a module overrides it.
          };

          # The module list is the core of your system: each entry is a NixOS module
          # that contributes options (settings) into the final system configuration.
          modules = [
            ./modules/overlays
            # 2.1) Your machine/profile-specific module tree.
            # Provide files like ./profiles/amd/default.nix, ./profiles/nvidia/default.nix, etc.
            ./profiles/${gpuProfile}

            # 2.2) Enable the Flatpak NixOS module to manage flatpaks declaratively.
            nix-flatpak.nixosModules.nix-flatpak

            # 2.3) Wire Home Manager at the *system* level. This ensures that
            # `home-manager.users.<name>` works *here* and stays tied to your system closure.
            home-manager.nixosModules.home-manager

            # 2.4) A small inline module for global switches that don’t deserve a separate file yet.
            {
              ######################
              # ALLOW UNFREE
              ######################
              # Some widely used packages are unfree (e.g., certain fonts, NVIDIA drivers, codecs).
              # Enabling this globally avoids duplicate per-user toggles.
              nixpkgs.config.allowUnfree = true;

              # Mirror the unfree toggle inside Home Manager for your user.
              # This only matters if your HM config tries to install unfree software.
              home-manager.users.${username}.nixpkgs.config.allowUnfree = true;

              ######################
              # HOME MANAGER BASE
              ######################
              # This ties a specific HM config to this host. You can either:
              #   A) Define a full HM module tree under ./home/${username}
              #   B) Inline a minimal HM config here (kept tiny for clarity)
              #
              # Pick (A) for maintainability: one place for your user’s home setup.
              # If you do (A), comment the inline example below and add:
              # home-manager.users.${username} = import ./home/${username};
              #
              # For now, a minimal inline example:
              home-manager.users.${username} = { pkgs, ... }: {
                # Ensure HM runs as a NixOS module (not standalone) and uses system pkgs.
                home.stateVersion = "25.05"; # Bump only when you understand the migration notes.
                programs.home-manager.enable = true;

                # Example: add zen as a user app if you like. You can move this into your HM files later.
                # home.packages = [ inputs.zen-browser.packages.${pkgs.system}.default ];

                # If you use Stylix/NVF/QuickShell HM modules, you can enable/import them here.
                # For example (uncomment when ready and you actually use them):
                # imports = [
                #   inputs.stylix.homeManagerModules.stylix
                #   inputs.nvf.homeManagerModules.default
                # ];
              };

              ######################
              # OPTIONAL: QUICKSHALL SYSTEM GLUE
              ######################
              # If QuickShell provides a NixOS or HM module you want, import it similarly.
              # Otherwise, just install the package where appropriate (system or user).
              # environment.systemPackages = [
              #   inputs.quickshell.packages.${system}.default
              # ];

              ######################
              # OPTIONAL: ZEN BROWSER SYSTEM-WIDE
              ######################
              # If you prefer zen browser system-wide instead of per-user:
              # environment.systemPackages = [
              #   inputs.zen-browser.packages.${system}.default
              # ];
            }
          ];
        };
    in

    ############################
    # 3) TOP-LEVEL OUTPUT ATTRS
    ############################
    {
      # Multiple host variants share the same base, differing only by GPU/profile module.
      # Each becomes buildable with `nixos-rebuild switch --flake .#amd` (or nvidia/intel/vm).
      nixosConfigurations = {
        amd           = mkNixosConfig "amd";
        nvidia        = mkNixosConfig "nvidia";
        nvidia-laptop = mkNixosConfig "nvidia-laptop";
        intel         = mkNixosConfig "intel";
        vm            = mkNixosConfig "vm";
      };

      # You can also export devShells, packages, overlays, etc., here if needed.
      # For example, a universal dev shell for editing this repo:
      # devShells.${system}.default = with import nixpkgs { inherit system; }; mkShell {
      #   buildInputs = [ git nixfmt-rfc-style ];
      # };
    };
}

