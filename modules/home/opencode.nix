{pkgs, ...}: {
  home.packages = with pkgs; [
    # Add your packages here
    unstable.opencode
  ];
}
