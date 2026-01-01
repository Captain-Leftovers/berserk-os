{...}: {
  # Write ~/.config/zed/settings.json from Nix
  home.file.".config/zed/settings.json".text = builtins.toJSON {
    vim_mode = true;
    # Prefer nixd over nil (and disable nil explicitly)
    languages = {
      Nix = {
        language_servers = ["nixd" "!nil"];
        formatter = {
          external = {
            command = "alejandra";
            arguments = ["--quiet" "--"];
          };
        };
      };
    };

    # nixd server configuration
    lsp.nixd.settings = {
      # Where nixd should pull pkgs/lib completion from;
      # with nix.nixPath set, this resolves to your flake's nixpkgs.
      nixpkgs.expr = "import <nixpkgs> { }";

      # Option completions (NixOS + HM-as-NixOS-module)
      # NOTE: edit host/user below to match your setup.
      options = {
        nixos = {
          # Your flake path + host name:
          # e.g. /home/beeondweb/zaneyos + berserk
          expr = "(builtins.getFlake \"/home/beeondweb/zaneyos\").nixosConfigurations.berserk.options";
        };

        # Home-Manager when used as a NixOS module lives under the NixOS option tree.
        # This exposes *Home-Manager* options for completion:
        home-manager = {
          expr = "(builtins.getFlake \"/home/beeondweb/zaneyos\").nixosConfigurations.berserk.options.home-manager.users.type.getSubOptions []";
        };
      };

      # Optional: pick the formatter for nixd's formatting capability (we also set Zed's external formatter above).
      formatting = {
        command = ["alejandra" "--quiet" "--"];
      };
    };
  };
}
