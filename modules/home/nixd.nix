{ host, username, flakeRoot,... }:
{
 programs.nixd = {
    enable = true;
    settings = {
      nixpkgs.expr = "import <nixpkgs> { }";
      formatting.command = [ "nixfmt" ];
      options = {
        nixos = {
          # Evaluate options from your NixOS host in your flake
          expr =
            ''(builtins.getFlake "${flakeRoot}").nixosConfigurations.${host}.options'';
        };
        home_manager = {
          # Evaluate Home Manager options from your user config in the same flake
          expr =
            ''(builtins.getFlake "${flakeRoot}").homeConfigurations.${username}.options'';
        };
      };
    };
  };

}
