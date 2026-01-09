{pkgs, ...}: {
  home.packages = with pkgs; [
    qflipper
  ];
}
