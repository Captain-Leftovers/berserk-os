{
  config,
  pkgs,
  ...
}: {
  home.pkgs = with pkgs; [
    zeal
  ];
}
