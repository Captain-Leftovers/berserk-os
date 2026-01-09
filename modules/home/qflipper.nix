{pkgs, ...}: {
  home.packages = with pkgs; [
    qFlipper
  ];
}
