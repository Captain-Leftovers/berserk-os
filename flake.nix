
{
  description = "BerserkOS";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";


    nvf.url = "github:notashelf/nvf";
    stylix.url = "github:danth/stylix/release-25.05";
    nix-flatpak.url = "github:gmodena/nix-flatpak?ref=latest";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
    zen-browser.inputs.home-manager.follows = "home-manager";

    # Hypersysinfo  (Optional)
    #hyprsysteminfo.url = "github:hyprwm/hyprsysteminfo";

    # QuickShell (optional add quickshell to outputs to enable)
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {

      nixpkgs,
      home-manager,
      nix-flatpak,
      quickshell,
      zen-browser,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
    host = "berserk";
    profile = "amd";
      username = "beeondweb";
      flakeRoot = toString ./.;

      # Deduplicate nixosConfigurations while preserving the top-level 'profile'
      mkNixosConfig = gpuProfile: nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {
          inherit flakeRoot;
          inherit inputs;
          inherit username;
          inherit host;
          inherit profile; # keep using the let-bound profile for modules/scripts
        };
        modules = [
          ./modules/overlays
          ./profiles/${gpuProfile}
         nix-flatpak.nixosModules.nix-flatpak
         {
          nixpkgs.config.allowUnfree = true;
          home-manager.users.${username}.nixpkgs.config.allowUnfree = true;
  }

        ];
      };
    in
    {
      nixosConfigurations = {
        amd = mkNixosConfig "amd";
        nvidia = mkNixosConfig "nvidia";
        nvidia-laptop = mkNixosConfig "nvidia-laptop";
        intel = mkNixosConfig "intel";
        vm = mkNixosConfig "vm";
      };

    };
}
