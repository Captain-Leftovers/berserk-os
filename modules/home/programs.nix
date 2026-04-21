{pkgs, ...}: {
  home.packages = with pkgs; [
    zeal
    blanket
    ddcutil
    lynx
  ];
}
