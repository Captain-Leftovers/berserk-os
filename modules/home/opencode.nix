{
  inputs,
  pkgs,
  ...
}: {
  home.packages = [
    inputs.opencode.packages.${pkgs.system}.opencode # CLI
    inputs.opencode.packages.${pkgs.system}.desktop # GUI/desktop
  ];
}
